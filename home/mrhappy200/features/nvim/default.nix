{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with inputs; {
  imports = [nixvim.homeManagerModules.nixvim];

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

      which-key.enable = true;

      # completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            {name = "nvim-lsp";}
            {name = "buffer";}
          ];
        };
      };
      #      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
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
