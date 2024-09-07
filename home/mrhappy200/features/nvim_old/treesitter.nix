{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixGrammars = true;
        indent = true;
        languageRegister = {html = "njk";};
      };
      treesitter-context = {
        enable = true;
        settings = {max_lines = 2;};
      };
      rainbow-delimiters.enable = true;
    };
  };
}
