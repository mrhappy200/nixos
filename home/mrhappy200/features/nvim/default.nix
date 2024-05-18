{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with inputs; {
  imports = [ nixvim.homeManagerModules.nixvim ];  

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    options = {
    number = true;
    relativenumber = true;

    shiftwidth = 2;
    };

    plugins = {
      lualine.enable = true;
      bufferline.enable = true;
      lsp = {
        enable = true;
	servers = {
          rust-analyzer.enable = true;
	  ltex.enable = true;
	  nixd.enable = true;
	};
      };

      # completion
      cmp = {
        enable = true;
	autoEnableSources = true;
	#sources = [
        #  {name = "nvim_lsp";}
	#  {name = "path";}
	#  {name = "buffer";}
	#];
      };
    };
  };

  home.persistence."/nix/persist/home/mrhappy200" = {
    directories = [
      ".cache/nvim"
      ".local/share/nvim"
      ".local/state/nvim"
    ];
    files = [];
  };
}
