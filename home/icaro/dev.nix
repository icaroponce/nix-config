# Dev tooling. Project-specific toolchains go in the project's flake.nix (devShell) + `.envrc`.
{ pkgs, ... }:
let
  # nvim-treesitter (main branch) with prebuilt grammars, merged into one folder.
  # The dotfiles' lazy.nvim spec loads it from vim.g.nix_treesitter instead of git (nothing compiles).
  treesitter =
    let
      ts = pkgs.vimPlugins.nvim-treesitter.withPlugins (
        g: with g; [
          c
          elixir
          elm
          go
          graphql
          haskell
          javascript
          json
          lua
          markdown
          markdown_inline
          nix
          python
          query
          terraform
          typescript
          vim
          vimdoc
        ]
      );
    in
    pkgs.symlinkJoin {
      name = "nvim-treesitter-with-grammars";
      paths = [ ts ] ++ ts.dependencies;
      # lazy.nvim runs :helptags on local plugins, which fails in the read-only store.
      postBuild = "rm -r $out/doc";
    };
in
{
  # direnv loads a project's env from .envrc on cd (hook in .zshrc).
  # nix-direnv: cached `use flake`, and the dev shell is kept from garbage collection.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Also used by the Claude Code LSP plugins, so on the normal PATH.
  home.packages = with pkgs; [
    lua-language-server
    typescript-language-server
    typescript_5 # tsserver (typescript-tools.nvim); typescript 7 has none
  ];

  # Config and plugins stay in dotfiles (lazy.nvim). This only adds tools to nvim's PATH.
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    sideloadInitLua = true; # never write ~/.config/nvim/init.lua (it's the dotfiles one)
    initLua = ''vim.g.nix_treesitter = "${treesitter}"''; # runs before init.lua
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
      # Language servers (nvim-lspconfig)
      python3Packages.python-lsp-server # pylsp
      vscode-langservers-extracted # eslint
      nixd # nix
      # Formatters / linters (conform, nvim-lint)
      stylua
      prettier
      yamllint
      luaPackages.luacheck
      nixfmt
    ];
  };
}
