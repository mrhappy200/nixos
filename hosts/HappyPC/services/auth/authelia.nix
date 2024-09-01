{...}: let
	in {
	services.authelia.instances."plsFriend" = {
		enable = true;
		settings = {
			telemetry.metrics.enabled = true;
			server.address = "unix:///var/run/authelia.sock?path=authelia&umask=0117";
			default_2fa_method = "totp";
		};
	};
}
