{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  services.xserver.videoDrivers = ["amdgpu"];
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    blueman
    bluetuith
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["amd_pstate=guided"];
  boot.initrd.kernelModules = ["amdgpu"];
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  networking.hostName = "mininix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  services.syncthing = {
    enable = true;
    user = "nicky";
    dataDir = "/home/nicky/Documents"; # Default folder for new synced folders
    configDir = "/home/nicky/.config/syncthing"; # Folder for Syncthing's settings and keys
  };
}
