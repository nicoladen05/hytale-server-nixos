{ lib, config, ... }:
{
  config = lib.mkIf config.nvf.enable {
    programs.nvf.settings.vim = {
      statusline.lualine = {
        enable = true;

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

      # tabline.nvimBufferline = {
      #   enable = true;
      #   mappings.closeCurrent = "<leader>x";
      #   mappings.cycleNext = "<S-i>";
      #   mappings.cyclePrevious = "<S-h>";
      #   setupOpts.options = {
      #     always_show_bufferline = false;
      #     diagnostics_indicator = null;
      #     indicator.style = "none";
      #     numbers = "none";
      #     show_buffer_close_icons = false;
      #     show_buffer_icons = false; # maybe
      #     show_close_icons = false;
      #     show_tab_indicators = false;
      #     style_preset = "minimal";
      #     tab_size = 8;
      #   };
      # };
    };
  };
}
