{...}: {
	services.jellyfin = {
		enable = true;
		user = "jellyfin";
		group = "mediastack";
		logDir = "/nix/persist-hdd/media/jellyfin/log/";
		cacheDir = "/nix/persist/jellycache/";
		dataDir = "/nix/persist-hdd/media/jellyfin/data/";
		configDir = "/nix/persist-hdd/media/jellyfin/config/";
	};

	services.jellyseerr.enable = true;
}
