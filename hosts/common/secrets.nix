{...}: {
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
    secrets.isw-vpn = {};
    secrets.claude-api-key = {
      owner = "nicky";
      group = "users";
    };
  };
}
