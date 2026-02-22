{ ... }: {
  xdg.configFile = {
    # modified dracula
    "tilix/schemes/dracula.json".text = builtins.toJSON {
      name = "Dracula (modified)";
      comment = "Ported for Terminix Colour Scheme";

      use-badge-color = false;
      use-bold-color = false;
      use-cursor-color = false;
      use-highlight-color = false;
      use-theme-colors = true;

      foreground-color = "#f8f8f2";
      background-color = "#1e1f29";
      cursor-background-color = "#000000";
      cursor-foreground-color = "#ffffff";
      highlight-background-color = "#000000";
      highlight-foreground-color = "#ffffff";

      palette = [
        "#000000"
        "#ff5555"
        "#50fa7b"
        "#f1fa8c"
        "#bd93f9"
        "#ff79c6"
        "#8be9fd"
        "#bbbbbb"
        "#555555"
        "#ff5555"
        "#50fa7b"
        "#f1fa8c"
        "#bd93f9"
        "#ff79c6"
        "#8be9fd"
        "#ffffff"
      ];
    };
  };
}