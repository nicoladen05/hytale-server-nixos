{
  lib,
  config,
  pkgs,
  ...
}:

{
  import = [
    ./plugins.nix
  ];

  options = {
    nvf.enable = lib.mkEnableOption "enable nvf";
  };

  config = lib.mkIf config.nvf.enable {
    # Set $EDITOR as nvim
    environment.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          options = {
            undofile = true;
            undodir = "/home/${config.system.userName}/.cache";

            autoindent = true;
            expandtab = true;
            shiftwidth = 2;
            smartindent = true;
            tabstop = 2;

            clipboard = "unnamedplus";

            termguicolors = true;

            mouse = "a";

            cursorline = true;
            number = true;
            relativenumber = true;
            signcolumn = "yes";

            autoread = true;
            backup = false;
            compatible = false;
            errorbells = false;
            hidden = true;
            incsearch = true;
            # shell = "zsh";
            shortmess = "atI";
            showmode = false;
            smartcase = true;
            swapfile = false;
            ttimeoutlen = 5;
            wrap = false;
            writebackup = false;
            encoding = "UTF-8";
          };

          globals = {
            mapleader = " ";
            maplocalleader = " ";
          };

          keymaps = [
            # Colemak mappings
            {
              key = "n";
              mode = "n";
              action = "j";
            }
            {
              key = "e";
              mode = "n";
              action = "k";
            }
            {
              key = "i";
              mode = "n";
              action = "l";
            }
            {
              key = "k";
              mode = "n";
              action = "i";
            }
            {
              key = "j";
              mode = "n";
              action = "n";
            }
            {
              key = "l";
              mode = "n";
              action = "e";
            }

            {
              key = "n";
              mode = "v";
              action = "j";
            }
            {
              key = "e";
              mode = "v";
              action = "k";
            }
            {
              key = "i";
              mode = "v";
              action = "l";
            }
            {
              key = "k";
              mode = "v";
              action = "i";
            }
            {
              key = "<S-k>";
              mode = "v";
              action = "I";
            }
            {
              key = "j";
              mode = "v";
              action = "n";
            }
            {
              key = "<S-j>";
              mode = "v";
              action = "N";
            }
            {
              key = "l";
              mode = "v";
              action = "e";
            }
            {
              key = "<S-l>";
              mode = "v";
              action = "E";
            }
            # Better window navigation
            {
              key = "<C-h>";
              mode = "n";
              action = "<C-w>h";
            }
            {
              key = "<C-n>";
              mode = "n";
              action = "<C-w>j";
            }
            {
              key = "<C-e>";
              mode = "n";
              action = "<C-w>k";
            }
            {
              key = "<C-i>";
              mode = "n";
              action = "<C-w>l";
            }

            # Resize with arrows
            {
              key = "<C-Up>";
              mode = "n";
              action = ":resize -2<CR>";
            }
            {
              key = "<C-Down>";
              mode = "n";
              action = ":resize +2<CR>";
            }
            {
              key = "<C-Left>";
              mode = "n";
              action = ":vertical resize -2<CR>";
            }
            {
              key = "<C-Right>";
              mode = "n";
              action = ":vertical resize +2<CR>";
            }

            # Navigate Buffers
            {
              key = "<S-h>";
              mode = "n";
              action = ":bprevious<CR>";
            }
            {
              key = "<S-i>";
              mode = "n";
              action = ":bnext<CR>";
            }

            # Stay in visual mode
            {
              key = ">";
              mode = "v";
              action = ">gv";
            }
            {
              key = "<";
              mode = "v";
              action = "<gv";
            }

            # Neotree
            {
              key = "<leader>n";
              mode = "n";
              action = "<cmd>Neotree toggle<cr>";
            }
          ];

          lsp = {
            enable = true;
            formatOnSave = true;
          };

          treesitter.autotagHtml = true;

          formatter.conform-nvim = {
            enable = true;
            setupOpts = {
              formatters_by_ft = {
                nix = [ "nixfmt" ];
                python = [
                  "black"
                  "isort"
                ];
                javascript = [ "prettierd" ];
                typescript = [ "prettierd" ];
                html = [ "prettierd" ];
              };
            };
          };

          languages = {
            enableTreesitter = true;
            enableFormat = true;

            nix = {
              enable = true;
              lsp.enable = true;
              treesitter.enable = true;
              format.enable = true;
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

            markdown.enable = true;
            rust.enable = true;
            # markdown.extensions.render-markdown-nvim.enable = true;
          };

          # Plugins
          statusline.lualine = {
            enable = true;
            # theme = "auto";

            componentSeparator = {
              left = "";
              right = "";
            };
            sectionSeparator = {
              left = "";
              right = "";
            };
            disabledFiletypes = [
              "statusline"
              "winbar"
            ];
            globalStatus = false;

            activeSection = {
              a = [
                ''
                  {
                    "mode",
                    icons_enabled = true
                  }
                ''
              ];
              b = [
                ''
                  {
                    "",
                    draw_empty = true,
                  }
                ''
              ];
              c = [
                ''
                  {
                    "filetype",
                    colored = true,
                    icon_only = true,
                    icon = { align = 'right' },
                  }
                ''
                ''
                  {
                    "filename",
                    symbols = { modified = '', readonly = ''},
                  }
                ''
              ];

              x = [
                ''
                  {
                    "searchcount"
                  }
                ''
                ''
                  {
                    "diagnostics",
                    symbols = {error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 '},
                    colored = true,
                  }
                ''
              ];
              y = [
                ''
                  {
                    "",
                    draw_empty = true,
                  }
                ''
              ];
              z = [
                ''
                  {
                    "branch",
                    icon = ' •',
                  }
                ''
              ];
            };
          };

          visuals = {
            nvim-web-devicons.enable = true;
          };

          autocomplete.nvim-cmp = {
            enable = true;
            sourcePlugins = [
              "cmp-buffer"
              "cmp-path"
              "cmp-luasnip"
            ];
          };

          filetree.neo-tree = {
            enable = true;
            setupOpts = {
              window = {
                width = 40;

                mappings = {
                  e = "";
                  l = "focus_preview";
                  i = "open";
                };
              };
            };
          };

          utility.surround = {
            enable = true;
            setupOpts = {
              keymaps = {
                change = "cs";
                change_line = "cS";
                delete = "ds";
                normal = "ys";
                normal_line = "yS";
              };
            };
          };

          # notes.obsidian = {
          #   enable = true;
          #   setupOpts.completion.nvim_cmp = true;
          # };

          assistant = {
            copilot = {
              enable = true;
              cmp.enable = true;
            };
          };

          telescope.enable = true;
          autopairs.nvim-autopairs.enable = true;
          dashboard.alpha.enable = true;
          presence.neocord.enable = true;
          notify.nvim-notify.enable = true;
          projects.project-nvim.enable = true;
          terminal.toggleterm.enable = true;
          terminal.toggleterm.lazygit.enable = true;
          comments.comment-nvim.enable = true;
          notes.todo-comments.enable = true;
          # ui.noice.enable = true;
          ui.colorizer.enable = true;
          ui.colorizer.setupOpts.user_default_options.tailwind = true;

          lazy.plugins = {
            # theme = {
            #   package = theme;
            # };

            # "gruvbox-material" = {
            #   package = pkgs.vimPlugins.gruvbox-material;
            #
            #   after = ''
            #     vim.g.gruvbox_material_enable_italic = true
            #     vim.g.gruvbox_material_background = 'medium'
            #     vim.g.gruvbox_material_foreground = 'material'
            #     vim.g.gruvbox_material_better_performance = true;
            #     vim.g.gruvbox_material_transparent_background = true;
            #     vim.cmd.colorscheme('gruvbox-material')
            #   '';
            # };

            # "codeium.nvim" = {
            #   package = pkgs.vimPlugins.codeium-nvim;
            #   setupModule = "codeium";
            #   setupOpts = {
            #     virtual_text.enabled = true;
            #   };
            # };
          };
        };
      };
    };
  };
}
