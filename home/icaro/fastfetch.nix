# "OS Age" is the birth time of /. Linux-only (`stat -c`).
{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings.modules = [
      "title"
      "separator"
      "os"
      {
        type = "command";
        key = "OS Age";
        text = ''
          born=$(stat -c %W /); days=$(( ($(date +%s) - born) / 86400 ))
          echo "$days day$([ $days = 1 ] || echo s) (installed $(date -d @$born +%F))"
        '';
      }
      "host"
      "kernel"
      "uptime"
      "packages"
      "shell"
      "wm"
      "terminal"
      "terminalfont"
      "cpu"
      "gpu"
      "memory"
      "swap"
      { type = "disk"; folders = "/"; } # only /, not USB sticks
      "locale"
      "break"
      "colors"
    ];
  };
}
