{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/hyprland.nix
  ];

  services.xserver.videoDrivers = ["amdgpu"];
  hardware.bluetooth.enable = true;

  services.synergy = {
    server = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    blueman
    bluetuith
    synergy
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

  boot.kernel.sysctl = {
    "vm.dirty_background_ratio" = 20;
    "vm.dirty_ratio" = 40;
  };
  services.journald.extraConfig = ''
    SyncIntervalSec=10s
  '';

  networking.hostName = "mininix"; # Define your hostname.

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Open ports in the firewall.
  networking.firewall.enable = false;
}