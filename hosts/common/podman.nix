{
  pkgs,
  unstable,
  ...
}: {
  environment.systemPackages = with pkgs; [
    podman-compose
    unstable.podman-desktop
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
