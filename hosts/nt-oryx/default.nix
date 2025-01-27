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

  # boot.kernelParams = [ "module_blacklist=i915" ];

  hardware.system76 = {
    enableAll = true;
    firmware-daemon.enable = true;
    kernel-modules.enable = true;
    power-daemon.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.systemPackages = with pkgs; [
    blueman
    bluetuith
    lshw
    lm_sensors
    postscript-lexmark
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = ["nvidia"];

  networking.hostName = "nt-oryx";
  networking.enableIPv6 = false;
  networking.search = ["internal.isw.net.au"];

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

  programs.light.enable = true;

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  # services.system76-scheduler.enable = true;
  # services.system76-scheduler.settings.cfsProfiles.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      # sudo tlp-stat or tlp-stat -s or sudo tlp-stat -p
      # CPU_BOOST_ON_AC = 1;
      # CPU_BOOST_ON_BAT = 0;
      # CPU_HWP_DYN_BOOST_ON_AC = 1;
      # CPU_HWP_DYN_BOOST_ON_BAT = 0;
      # CPU_SCALING_GOVERNOR_ON_AC = "performance";
      # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      # CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      # CPU_SCALING_MIN_FREQ_ON_AC = 400000; # 400 MHz
      # CPU_SCALING_MAX_FREQ_ON_AC = 5400000; # 5.4 GHz
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 81;
    };
  };
}
