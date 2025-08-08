{
  config,
  lib,
  pkgs,
  ...
}: {
  # MongoDB Compass connection management script
  home.file.".local/bin/compass-with-favorites.sh" = {
    text = ''
      #!/usr/bin/env bash

      # MongoDB Compass Favorites Manager
      # Rebuilds connection favorites from pass/sops secrets before launching

      COMPASS_DIR="$HOME/.config/MongoDB Compass/Connections"

      # Ensure connections directory exists
      mkdir -p "$COMPASS_DIR"

      # Clear existing connections (they get recreated)
      rm -f "$COMPASS_DIR"/*.json

      # Function to create a connection file
      create_connection() {
          local name="$1"
          local connection_string="$2"
          local color="$3"
          local uuid=$(uuidgen)

          cat > "$COMPASS_DIR/$uuid.json" << EOF
      {
        "_id": "$uuid",
        "connectionInfo": {
          "id": "$uuid",
          "connectionOptions": {
            "connectionString": "$connection_string"
          },
          "savedConnectionType": "favorite",
          "favorite": {
            "name": "$name",
            "color": "$color"
          },
          "lastUsed": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"
        },
        "connectionSecrets": "",
        "version": 1
      }
      EOF
      }

      # Load MongoDB connections from pass secrets
      # Store your connections in pass as JSON, e.g.:
      # pass insert -m mongodb/connections
      # Then paste JSON like:
      # [
      #   {"name": "Client Production", "uri": "mongodb+srv://user:pass@cluster.net/", "color": "color1"},
      #   {"name": "Client Staging", "uri": "mongodb+srv://user:pass@staging.net/", "color": "color2"}
      # ]

      if command -v pass >/dev/null 2>&1 && pass show mongodb/connections >/dev/null 2>&1; then
          echo "Loading MongoDB connections from pass..."
          CONNECTIONS_JSON=$(pass show mongodb/connections)

          # Parse JSON and create connections
          echo "$CONNECTIONS_JSON" | jq -r '.[] | @base64' | while read -r encoded; do
              name=$(echo "$encoded" | base64 -d | jq -r '.name')
              uri=$(echo "$encoded" | base64 -d | jq -r '.uri')
              color=$(echo "$encoded" | base64 -d | jq -r '.color')
              create_connection "$name" "$uri" "$color"
          done
      else
          echo "No MongoDB connections found in pass, using local development only..."
          # Fallback: only local development (no sensitive data)
          create_connection "Local Development" "mongodb://localhost:27017" "color1"
      fi

      echo "MongoDB Compass favorites rebuilt from configuration"

      # Launch MongoDB Compass and wait for it to exit
      mongodb-compass "$@"

      # Clear only saved passwords/connections after Compass exits
      echo "MongoDB Compass exited, clearing saved connections and passwords..."
      rm -f "$COMPASS_DIR"/*.json

      # Keep browsing history, cached queries, and other useful data
      # Only clear authentication cookies that might contain session tokens
      rm -f "$HOME/.config/MongoDB Compass/Cookies"
      rm -f "$HOME/.config/MongoDB Compass/Cookies-journal"

      echo "MongoDB Compass passwords cleared (history and queries preserved)"
    '';
    executable = true;
  };

  # Desktop entry for managed launcher and hide default
  xdg.desktopEntries = {
    mongodb-compass-managed = {
      name = "MongoDB Compass (managed)";
      comment = "Rebuild favorites from secrets and launch MongoDB Compass";
      exec = "${config.home.homeDirectory}/.local/bin/compass-with-favorites.sh";
      icon = "mongodb-compass";
      terminal = false;
      categories = ["Development" "Database"];
      mimeType = ["x-scheme-handler/mongodb"];
    };

    # Hide the default MongoDB Compass entry
    mongodb-compass = {
      name = "MongoDB Compass";
      noDisplay = true;
    };
  };
}
