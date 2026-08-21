{ ... }: {
  services.weechat = {
    enable = true;
  };
  # This allows other users to access the weechat screen session with the following command
  # screen -x weechat/weechat-screen
  programs.screen.enable = true;
  programs.screen.screenrc = ''
    multiuser on
    acladd mrhappy200
  '';

  environment.persistence."/persist".directories = [ "/var/lib/weechat" ];
}
