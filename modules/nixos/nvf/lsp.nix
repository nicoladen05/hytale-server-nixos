{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.nvf.enable {
    programs.nvf.settings.vim = {
      lsp = {
        enable = true;
        formatOnSave = false;
        mappings = {
          goToDefinition = "gd";
          goToDeclaration = "gD";
          listReferences = "gr";
          hover = "K";
          openDiagnosticFloat = "gi";
        };
      };

      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = false;
          format.package = pkgs.nixfmt;
          format.type = "nixfmt";
        };
        python = {
          enable = true;
          lsp.enable = true;
          lsp.package = pkgs.pyright;
          lsp.server = "pyright";
          format.enable = true;
          format.type = "black-and-isort";
        };
        ts = {
          enable = true;
          extraDiagnostics.enable = true;
          format.enable = true;
          format.type = "prettierd";
          lsp.enable = true;
          lsp.server = "ts_ls";
          treesitter.enable = true;
        };
        html = {
          enable = true;
          treesitter.enable = true;
          treesitter.autotagHtml = true;
        };
        tailwind = {
          enable = true;
          lsp.enable = true;
        };
        csharp = {
          enable = true;
          lsp.enable = true;
        };

        markdown.enable = true;
        rust.enable = true;
        # markdown.extensions.render-markdown-nvim.enable = true;
      };
    };
  };
}
