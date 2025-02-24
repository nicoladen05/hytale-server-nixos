{ lib, pkgs, inputs, ...}:

{
  stylix.enable = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

  # stylix.base16Scheme = {
  # base00 = "282828";
  # base01 = "32302f";
  # base02 = "504945";
  # base03 = "665c54";
  # base04 = "bdae93";
  # base05 = "ddc7a1";
  # base06 = "ebdbb2";
  # base07 = "fbf1c7";
  # base08 = "ea6962";
  # base09 = "e78a4e";
  # base0A = "d8a657";
  # base0B = "a9b665";
  # base0C = "89b482";
  # base0D = "7daea3";
  # base0E = "d3869b";
  # base0F = "bd6f3e";
  # };

  stylix.image = pkgs.fetchurl {
    url = "https://xcu37g90vd.ufs.sh/f/gISQwWsUpMTPCyMXPPTvFiwZ9rz0MeyfSD2VXAElBUHsoJuT";
    sha256 = "sha256-NduOrnuMG7HcSLVH6Cj6/TIs/fL2kC1gq+O6IGOiEn8=";
  };

  stylix.cursor.package = pkgs.apple-cursor;
  stylix.cursor.name = "macOS";
  stylix.cursor.size = 28;


  stylix.opacity = {
    terminal = 0.95;
    applications = 0.95;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
   sansSerif = {
     package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
     name = "SFProDisplay Nerd Font";
   };
   serif = {
     package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
     name = "SFProDisplay Nerd Font";
   };
  };

  stylix.fonts.sizes = {
    terminal = 14;
    desktop = 13;
    applications = 11;
  };

  stylix.targets.nixvim.enable = true;
  stylix.targets.nixvim.transparentBackground.main = true;
  stylix.targets.nixvim.transparentBackground.signColumn = true;
}
