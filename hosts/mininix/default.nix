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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
}
