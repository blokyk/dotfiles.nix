{ config, ... }: {
  home.sessionVariables = {
    TERM = "xterm-256color";
    ANDROID_HOME = config.home.homeDirectory + "/Android/Sdk";
  };
}
