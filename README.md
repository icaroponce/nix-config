# nix-config

NixOS + home-manager config for a ThinkPad T450s running xmonad.

```
flake.nix               nixosConfigurations.t450s + homeConfigurations."icaro@t450s"
hosts/common/global/    every machine: boot, nix, network, locale, base packages
hosts/common/features/  optional pieces: xmonad, audio, docker
hosts/common/users/     user accounts
hosts/t450s/            host: disk layout (fs.nix), generated hardware config
home/icaro/common.nix   user packages shared by all machines
home/icaro/dev.nix      dev tools: direnv + nix-direnv, neovim with LSPs and treesitter grammars
home/icaro/t450s.nix    per-machine user packages, monitors, fastfetch
templates/haskell/      project template: cabal + GHC/HLS from nixpkgs, direnv, justfile
```

- Full-disk encryption (LUKS2), btrfs subvolumes, systemd-boot. See [INSTALL.md](INSTALL.md).
- home-manager runs standalone, so `home/` also works on non-NixOS systems.
- App configs (xmonad, xmobar, nvim, kitty, zsh, ...) live in
  [dotfiles](https://github.com/icaroponce/dotfiles), linked with `stow --no-folding`.

## Usage

```sh
nh os switch        # sudo nixos-rebuild switch --flake .#t450s
nh home switch      # home-manager switch --flake .#icaro@t450s
nh os switch -u     # update flake.lock first
nh clean all -k 5   # drop old generations
```

Flakes only see files tracked by git: `git add` new files before rebuilding.

New Haskell project: `nix flake init -t ~/nix-config#haskell`, then `direnv allow`.
