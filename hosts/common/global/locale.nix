{lib, ...}: {
  i18n = {
    #defaultLocale = lib.mkDefault "fr_FR.UTF-8";
    defaultLocale = lib.mkDefault "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_TIME = lib.mkDefault "nl_NL.UTF-8";
    };
    supportedLocales = lib.mkDefault [
      "en_GB.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
      "nl_NL.UTF-8/UTF-8"
    ];
  };
  location.provider = "geoclue2";
  time.timeZone = lib.mkDefault "Europe/Amsterdam";
}
