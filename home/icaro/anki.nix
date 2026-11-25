# Anki with add-ons from Nix (Tools -> Add-ons shows them; their config comes from here).
{ pkgs, ... }:
let
  # Colored answer buttons + last answer shown in the toolbar. Not in nixpkgs.
  flexible-grading = pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
    pname = "flexible-grading";
    version = "26.9.1.0";
    # Release build (the git source pulls a submodule over ssh).
    src = pkgs.fetchzip {
      url = "https://github.com/Ajatt-Tools/FlexibleGrading/releases/download/v${finalAttrs.version}/ajt_flexible_grading.ankiaddon";
      extension = "zip";
      stripRoot = false;
      hash = "sha256-Wn7JGF4lG02v/lQISEFZpTQ7XHaBprdvzvDS++uVH/A=";
    };
  });
in
{
  home.packages = [
    (pkgs.anki.withAddons (
      with pkgs.ankiAddons;
      [
        anki-connect # API on localhost:8765 (used by german-vocab)
        review-heatmap # review calendar + streaks
        (flexible-grading.withConfig {
          # Defaults are opinionated (hidden buttons, pass/fail only, grading from the front):
          # keep Anki's normal reviewer, add the colors and the last answer.
          config = {
            color_buttons = true;
            show_last_review = true;
            remove_buttons = false;
            prevent_clicks = false;
            pass_fail = false;
            flexible_grading = false;
            remember_zoom_level = false; # it saves zoom on every screen change: read-only config here
          };
        })
      ]
    ))
  ];
}
