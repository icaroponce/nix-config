# Docker with NixOS defaults (`docker compose` included).
{ ... }:
{
  virtualisation.docker.enable = true;
  users.users.icaro.extraGroups = [ "docker" ]; # docker without sudo (after re-login)
}
