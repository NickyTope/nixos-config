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
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "dev-client.isw.net.au" = {
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
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };
      "dev-server.isw.net.au" = {
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
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          proxyWebsockets = true;
        };
      };
      "collablocal.huddo.com" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
        ];
        addSSL = true;
        sslCertificate = "/var/lib/ssl/collabcert.crt";
        sslCertificateKey = "/var/lib/ssl/collabkey.key";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
        locations."/editor" = {
          proxyPass = "http://127.0.0.1:27012";
          proxyWebsockets = true;
        };
      };
    };
  };

  networking.hosts = {
    "127.0.0.1" = ["dev-client.isw.net.au" "dev-server.isw.net.au" "collablocal.huddo.com" "host.docker.internal"];
  };
}
