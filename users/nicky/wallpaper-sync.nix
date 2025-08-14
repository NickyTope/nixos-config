{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rclone
  ];

  # Create wallpaper sync scripts
  home.file.".local/bin/setup-wallpaper-sync.sh" = {
    text = ''
      #!/usr/bin/env bash

      # Google Drive wallpaper sync setup script using rclone

      set -e

      WALLS_DIR="$HOME/Pictures/walls"
      GDRIVE_REMOTE="gdrive"
      GDRIVE_WALLS_PATH="wallpapers"

      # Colors
      GREEN='\033[0;32m'
      BLUE='\033[0;34m'
      YELLOW='\033[1;33m'
      NC='\033[0m'

      log() { echo -e "''${BLUE}[INFO]''${NC} $1"; }
      success() { echo -e "''${GREEN}[SUCCESS]''${NC} $1"; }
      warning() { echo -e "''${YELLOW}[WARNING]''${NC} $1"; }

      echo "Google Drive Wallpaper Sync Setup"
      echo "================================="

      # Check if rclone is installed
      if ! command -v rclone &> /dev/null; then
          echo "rclone not found. Please run rebuild first"
          exit 1
      fi

      # Check if rclone is already configured
      if rclone listremotes | grep -q "^''${GDRIVE_REMOTE}:$"; then
          log "rclone Google Drive remote '$(GDRIVE_REMOTE' already configured"
      else
          log "Setting up rclone Google Drive remote..."
          echo
          warning "You'll need to authorize rclone with your Google account"
          warning "Follow the prompts to complete OAuth setup"
          echo
          
          rclone config create "''${GDRIVE_REMOTE}" drive
          
          if rclone listremotes | grep -q "^''${GDRIVE_REMOTE}:$"; then
              success "Google Drive remote configured successfully"
          else
              echo "Failed to configure Google Drive remote"
              exit 1
          fi
      fi

      # Test the connection
      log "Testing Google Drive connection..."
      if rclone lsd "''${GDRIVE_REMOTE}:" &> /dev/null; then
          success "Google Drive connection working"
      else
          echo "Failed to connect to Google Drive"
          exit 1
      fi

      # Create wallpapers directory on Google Drive if it doesn't exist
      log "Creating wallpapers directory on Google Drive..."
      rclone mkdir "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" 2>/dev/null || true

      # Check if we need to download from Google Drive
      if [ ! -d "''${WALLS_DIR}" ]; then
          log "No local wallpapers directory found"
          log "Creating local directory and downloading from Google Drive..."
          
          mkdir -p "''${WALLS_DIR}"
          rclone sync "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" "''${WALLS_DIR}/" --progress --transfers=4 --exclude=".git/**"
          success "Downloaded wallpapers from Google Drive"
      else
          log "Local wallpapers directory found at ''${WALLS_DIR}"
          log "Use 'sync-wallpapers.sh download' to sync from Google Drive if needed"
      fi

      echo
      success "Wallpaper sync setup complete!"
      echo
      log "Commands you can use:"
      echo "  sync-wallpapers.sh upload    # Upload changes to Google Drive"
      echo "  sync-wallpapers.sh download  # Download changes from Google Drive"
      echo "  sync-wallpapers.sh status    # Check sync status"
    '';
    executable = true;
  };

  home.file.".local/bin/sync-wallpapers.sh" = {
    text = ''
      #!/usr/bin/env bash

      # Wallpaper sync script - syncs wallpapers between local and Google Drive

      WALLS_DIR="$HOME/Pictures/walls"
      GDRIVE_REMOTE="gdrive"
      GDRIVE_WALLS_PATH="wallpapers"

      # Colors
      GREEN='\033[0;32m'
      BLUE='\033[0;34m'
      YELLOW='\033[1;33m'
      RED='\033[0;31m'
      NC='\033[0m'

      log() { echo -e "''${BLUE}[INFO]''${NC} $1"; }
      success() { echo -e "''${GREEN}[SUCCESS]''${NC} $1"; }
      warning() { echo -e "''${YELLOW}[WARNING]''${NC} $1"; }
      error() { echo -e "''${RED}[ERROR]''${NC} $1"; }

      show_help() {
          echo "Wallpaper Sync Script"
          echo "Usage: $0 [COMMAND]"
          echo
          echo "Commands:"
          echo "  upload    - Upload local changes to Google Drive"
          echo "  download  - Download changes from Google Drive"
          echo "  bisync    - Two-way sync (experimental)"
          echo "  status    - Show sync status"
          echo "  help      - Show this help"
          echo
          echo "Examples:"
          echo "  $0 upload    # Push local wallpapers to Google Drive"
          echo "  $0 download  # Pull wallpapers from Google Drive"
      }

      check_setup() {
          if ! command -v rclone &> /dev/null; then
              error "rclone not installed"
              exit 1
          fi
          
          if ! rclone listremotes | grep -q "^''${GDRIVE_REMOTE}:$"; then
              error "rclone Google Drive remote not configured"
              error "Run setup-wallpaper-sync.sh first"
              exit 1
          fi
      }

      sync_upload() {
          log "Uploading local wallpapers to Google Drive..."
          if [ ! -d "''${WALLS_DIR}" ]; then
              error "Local wallpapers directory not found: ''${WALLS_DIR}"
              exit 1
          fi
          
          rclone sync "''${WALLS_DIR}/" "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" --progress --transfers=4 --exclude=".git/**"
          success "Upload complete"
      }

      sync_download() {
          log "Downloading wallpapers from Google Drive..."
          mkdir -p "''${WALLS_DIR}"
          
          rclone sync "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" "''${WALLS_DIR}/" --progress --transfers=4 --exclude=".git/**"
          success "Download complete"
      }

      sync_bisync() {
          log "Starting two-way sync..."
          warning "This is experimental - make sure you have backups!"
          
          mkdir -p "''${WALLS_DIR}"
          
          # First run needs --resync
          if [ ! -f "$HOME/.cache/rclone/bisync/gdrive_wallpapers.dat" ]; then
              log "First bisync run, initializing..."
              rclone bisync "''${WALLS_DIR}/" "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" --resync --progress --exclude=".git/**"
          else
              rclone bisync "''${WALLS_DIR}/" "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" --progress --exclude=".git/**"
          fi
          
          success "Bisync complete"
      }

      show_status() {
          log "Sync status:"
          echo
          
          if [ -d "''${WALLS_DIR}" ]; then
              local_count=$(find "''${WALLS_DIR}" -type f | wc -l)
              local_size=$(du -sh "''${WALLS_DIR}" | cut -f1)
              log "Local: ''${local_count} files, ''${local_size}"
          else
              warning "Local wallpapers directory not found"
          fi
          
          if rclone lsd "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" &> /dev/null; then
              remote_count=$(rclone lsf "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" --recursive | wc -l)
              remote_size=$(rclone size "''${GDRIVE_REMOTE}:''${GDRIVE_WALLS_PATH}" --json | ${pkgs.jq}/bin/jq -r '.bytes' | numfmt --to=iec)
              log "Google Drive: ''${remote_count} files, ''${remote_size}"
          else
              warning "Google Drive wallpapers directory not found"
          fi
      }

      case "''${1:-help}" in
          upload)
              check_setup
              sync_upload
              ;;
          download)
              check_setup
              sync_download
              ;;
          bisync)
              check_setup
              sync_bisync
              ;;
          status)
              check_setup
              show_status
              ;;
          help|--help|-h)
              show_help
              ;;
          *)
              error "Unknown command: $1"
              echo
              show_help
              exit 1
              ;;
      esac
    '';
    executable = true;
  };

  # Add scripts to PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Create systemd user service for automatic syncing (optional)
  systemd.user.services.wallpaper-sync = {
    Unit = {
      Description = "Sync wallpapers with Google Drive";
      After = [ "network-online.target" ];
    };
    
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.local/bin/sync-wallpapers.sh download";
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  # Optional: Timer to sync wallpapers periodically
  systemd.user.timers.wallpaper-sync = {
    Unit = {
      Description = "Sync wallpapers periodically";
    };
    
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
    
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}