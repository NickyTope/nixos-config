{ pkgs, inputs, ... }:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [ sops age proton-pass ];

  sops = {
    age.keyFile = "/home/nicky/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      openai = { };
      notes-share = { };
      github = { path = "/home/nicky/.ssh/github"; };
      github-pub = { path = "/home/nicky/.ssh/github.pub"; };
    };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
