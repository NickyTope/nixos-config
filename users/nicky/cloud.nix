{
  config,
  pkgs,
  ...
}: let
  google-cloud = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in {
  home.packages = with pkgs; [
    google-cloud
    ibmcloud-cli
    kubectl
  ];
}
