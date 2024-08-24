{pkgs, ...}:
{
	home.packages = [ pkgs.slack];
	home.sessionVariables.NIXOS_OZONE_WL = "1";
}
