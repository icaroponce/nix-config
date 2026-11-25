# Default apps for xdg-open, Brave downloads, Thunar... (writes ~/.config/mimeapps.list).
{ lib, ... }:
let
  # mime types -> one desktop file
  assign = desktop: types: lib.genAttrs types (_: desktop);
in
{
  # Terminal apps opened from GUI programs (hidden from the launcher).
  xdg.desktopEntries = {
    nvim-kitty = {
      name = "Neovim (kitty)";
      exec = "kitty -e nvim %F";
      noDisplay = true;
    };
    yazi-kitty = {
      name = "yazi (kitty)";
      exec = "kitty -e yazi %f";
      noDisplay = true;
    };
  };

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
      // assign "nvim-kitty.desktop" [
        "text/plain"
        "text/markdown"
        "text/x-python"
        "text/x-haskell"
        "text/x-shellscript"
        "application/x-shellscript"
        "application/json"
        "application/x-yaml"
        "application/toml"
      ]
      // assign "yazi-kitty.desktop" [
        "inode/directory"
        "application/zip" # opens yazi on the archive (extract there or with `ouch d`)
      ]
      // {
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop"; # Claude Code login links
      };
  };
  # Apps sometimes write their own mimeapps.list; replace it instead of failing the switch.
  xdg.configFile."mimeapps.list".force = true;
}
