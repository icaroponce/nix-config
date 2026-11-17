# User config shared by all machines (platform-neutral). App configs come from dotfiles via stow.
{ pkgs, inputs, ... }:
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  home.username = "icaro";

  home.packages = with pkgs; [
    ripgrep # rg: fast grep
    fd # fast find
    fzf # fuzzy finder (Ctrl-R, Ctrl-T)
    bat # cat with syntax highlighting
    eza # ls replacement
    zoxide # smart cd (`z`, `zi`)
    jq # JSON processor
    yazi # terminal file manager ($FILE)
    calcurse # terminal calendar (alias c)
    pay-respects # fixes the last command (`fuck`)
    dua # disk usage (`dua i` = interactive)
    ouch # pack/unpack any archive: `ouch d file.zip`, `ouch c dir out.tar.zst`
    nix-tree # browse nix store dependencies and sizes
    nix-du # graph of what keeps the nix store big
    glow # markdown viewer
    just # command runner (justfiles)
    python3
    direnv # per-project env from .envrc
  ];

  # `, <program>` runs any nixpkgs program without installing it.
  programs.nix-index-database.comma.enable = true;

  # Writes ~/.config/git/config.
  programs.git = {
    enable = true;
    ignores = [ ".direnv" ]; # direnv's per-project cache
    settings = {
      user = {
        name = "icaroponce";
        email = "ponceicaro@gmail.com";
      };
      # GitHub HTTPS auth through gh.
      credential."https://github.com".helper = [ "" "!${pkgs.gh}/bin/gh auth git-credential" ];
      credential."https://gist.github.com".helper = [ "" "!${pkgs.gh}/bin/gh auth git-credential" ];
    };
  };
  # git diffs through delta.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # Sourced by .zshrc from $ZDOTDIR/plugins. Needs `stow --no-folding` (~/.config/zsh must be a real dir).
  xdg.configFile = {
    "zsh/plugins/zsh-autosuggestions.zsh".source =
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    "zsh/plugins/zsh-syntax-highlighting.zsh".source =
      "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    "zsh/plugins/zsh-history-substring-search.zsh".source =
      "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
  };

  programs.home-manager.enable = true;
}
