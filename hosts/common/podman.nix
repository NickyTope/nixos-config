{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    podman-compose
    podman-desktop
  ];

  virtualisation.podman.enable = true;
}
