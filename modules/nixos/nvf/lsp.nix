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

        servers = {
          python.cmd = [ "${pkgs.pyright}/bin/pyright" ];

          nix = {
            cmd = [ "${pkgs.nixd}/bin/nixd" ];
            options = {
              nixos = {
                expr = "(builtins.getFlake \"github:nicoladen05/nix\").nixosConfigurations.desktop.options";
              };
              nixos_vps = {
                expr = "(builtins.getFlake \"github:nicoladen05/nix\").nixosConfigurations.vps.options";
              };
            };
          };
        };
      };

      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix = {
          enable = true;
          lsp = {
            enable = true;
            server = "nixd";
          };
          treesitter.enable = true;
          format.enable = false;
          format.package = pkgs.alejandra;
          format.type = "alejandra";
        };
        python = {
          enable = true;
          lsp.enable = true;
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
