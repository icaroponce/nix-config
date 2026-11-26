# Default apps (writes ~/.config/mimeapps.list). xdg-open is replaced by `gio open`, so the
# shell, Brave and Thunar all use GIO: subtypes fall back to their parent (lua, nix... -> text/plain)
# and Terminal=true apps (nvim, yazi) open in kitty via xdg-terminal-exec.
{ lib, pkgs, ... }:
let
  # mime types -> one desktop file
  assign = desktop: types: lib.genAttrs types (_: desktop);
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      assign "nsxiv.desktop" [
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/bmp"
        "image/tiff"
        "image/avif"
        "image/svg+xml"
      ]
      // assign "org.pwmt.zathura-pdf-mupdf.desktop" [
        "application/pdf"
        "application/epub+zip"
        "application/oxps"
      ]
      // assign "org.pwmt.zathura-djvu.desktop" [
        "image/vnd.djvu"
        "image/x-djvu"
      ]
      // assign "org.pwmt.zathura-ps.desktop" [ "application/postscript" ]
      // assign "org.pwmt.zathura-cb.desktop" [
        "application/x-cbz"
        "application/x-cbr"
        "application/vnd.comicbook+zip"
        "application/vnd.comicbook-rar"
      ]
      // assign "mpv.desktop" [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/quicktime"
        "video/x-msvideo"
        "video/mpeg"
        "video/ogg"
        "audio/mpeg"
        "audio/flac"
        "audio/ogg"
        "audio/opus"
        "audio/x-wav"
        "audio/aac"
        "audio/mp4"
      ]
      // assign "brave-browser.desktop" [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ]
      // assign "nvim.desktop" [ "text/plain" ] # every text type falls back to it
      // assign "yazi.desktop" [
        "inode/directory"
        "application/zip" # opens yazi on the archive (extract there or with `ouch d`)
      ]
      // {
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop"; # Claude Code login links
      };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "xdg-open" ''exec ${pkgs.glib.bin}/bin/gio open "$@"'')
    pkgs.xdg-terminal-exec # GIO runs Terminal=true apps with it
  ];
  xdg.configFile."xdg-terminals.list".text = "kitty.desktop\n";

  # Apps sometimes write their own mimeapps.list; replace it instead of failing the switch.
  xdg.configFile."mimeapps.list".force = true;
}
