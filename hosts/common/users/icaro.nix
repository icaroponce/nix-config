{ pkgs, ... }:
{
  # Password set imperatively with `passwd`.
  users.users.icaro = {
    isNormalUser = true;
    description = "Icaro";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # sudo
      "networkmanager"
      "video"
      "audio"
    ];
  };
}
