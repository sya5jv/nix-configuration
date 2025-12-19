{ pkgs, ...}: {

  boot.loader.limine.style = {
    wallpapers = [];
    graphicalTerminal = {
      palette = "";
      brightPalette = "";
      foreground = "";
      background = "";
      brightForeground = "";
      brightBackground = "";
      font.scale = "2x2";
    };
  };

  packages = with pkgs; [];

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      iosevka
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
  };

}
