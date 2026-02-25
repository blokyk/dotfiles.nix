# colorful diff viewer
{ ... }: {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      feature = "interactive";
      navigate = true; # activates diff navigation: use 'n' to jump forward and 'N' to jump backwards
      plus-style = "syntax #012800";
      minus-style = "syntax #340001";
      syntax-theme = "Monokai Extended";
      line-numbers = true;
      side-by-side = true;
      wrap-max-lines = 3;
      whitespace-error-style = "22 reverse";
    };
  };
}