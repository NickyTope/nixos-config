{pkgs, ...}: {
  imports = [
    ./xfce-bspwm.nix
    ./esphome.nix
    ./programs.nix
    ./podman.nix
    ./dev-proxy.nix
    ./isw-vpn.nix
    ./secrets.nix
  ];

  # Enable networking
  networking = {
    # this only works for lan
    # for wifi just disable ip6 when setting up the connections
    enableIPv6 = false;
    networkmanager = {
      enable = true;
    };
    nameservers = [
      "203.50.2.71"
      "1.0.0.19"
      "1.1.1.1"
    ];
    extraHosts = ''
      127.0.0.1 mongo minio redis
    '';
  };

  # Set your time zone.
  time.timeZone = "Australia/Hobart";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.libinput = {
    enable = true;
    mouse = {
      naturalScrolling = true;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = [ "root" "nicky" ];
  nix.optimise = {
    automatic = true;
    dates = ["02:00"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nicky = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Nicky Tope";
    extraGroups = ["networkmanager" "wheel" "docker" "video"];
    packages = with pkgs; [
      gcc
    ];
  };

  security.sudo.extraRules = [
    {
      users = ["nicky"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
