{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.eduvpn-client ];
}
