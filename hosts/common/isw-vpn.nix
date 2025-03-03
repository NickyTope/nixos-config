{...}: {
  services.openvpn.servers = {
    isw = {
      config = ''config /run/secrets/isw-vpn '';
      updateResolvConf = true;
      autoStart = false;
    };
  };
}
