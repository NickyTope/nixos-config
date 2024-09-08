{ pkgs, ... }:

{

  # installed from flake
  # programs.wezterm.enable = true;

  programs.wezterm.extraConfig = ''
    ${builtins.readFile ../../dotfiles/wezterm/wezterm.lua}
  '';
}
