{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/nicky/.config/sops/age/keys.txt";
    secrets.iswcert = {
      owner = "nginx";
      group = "nginx";
      path = "/var/lib/ssl/iswwccertchain.crt";
    };
    secrets.iswkey = {
      owner = "nginx";
      group = "nginx";
      path = "/var/lib/ssl/iswwckey.key";
    };
    secrets.collabcert = {
      owner = "nginx";
      group = "nginx";
      path = "/var/lib/ssl/collabcert.crt";
    };
    secrets.collabkey = {
      owner = "nginx";
      group = "nginx";
      path = "/var/lib/ssl/collabkey.key";
    };
  };
  services.nginx = let
    common = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
      ];
      addSSL = true;
      sslCertificate = "/var/lib/ssl/iswwccertchain.crt";
      sslCertificateKey = "/var/lib/ssl/iswwckey.key";
    };
  in {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "dev-client.isw.net.au" =
        common
        // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
            proxyWebsockets = true;
          };
        };
      "dev-server.isw.net.au" =
        common
        // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:3001";
            proxyWebsockets = true;
          };
        };
      "collablocal.huddo.com" =
        common
        // {
          sslCertificate = "/var/lib/ssl/collabcert.crt";
          sslCertificateKey = "/var/lib/ssl/collabkey.key";
          locations."/wikis" = {
            proxyPass = "http://127.0.0.1:9454";
            proxyWebsockets = true;
          };
          locations."/socketcluster" = {
            proxyPass = "http://127.0.0.1:3456";
            proxyWebsockets = true;
          };
          locations."/ideas" = {
            proxyPass = "http://127.0.0.1:4332";
            proxyWebsockets = true;
          };
          locations."/editor" = {
            proxyPass = "http://127.0.0.1:27012";
            proxyWebsockets = true;
          };
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
            proxyWebsockets = true;
          };
        };
    };
  };

  networking.hosts = {
    "127.0.0.1" = ["dev-client.isw.net.au" "dev-server.isw.net.au" "collablocal.huddo.com" "host.docker.internal"];
  };
}
