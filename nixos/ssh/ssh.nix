{

  services.openssh.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      8384
      22000
    ];
    allowedUDPPorts = [
      21027
      22000
    ];
  };

}
