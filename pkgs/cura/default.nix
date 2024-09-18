let
  pname = "cura";
  version = "5.4.0";
in
  {
    pkgs,
    lib,
  }:
    let cura5 = pkgs.appimageTools.wrapType2 {
      name = pname;
      src = pkgs.fetchurl {
        url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-modern.AppImage";
        sha256 = "sha256-QVv7Wkfo082PH6n6rpsB79st2xK2+Np9ivBg/PYZd74=";
      };

      meta = with pkgs.lib; {
        description = "An open-source alternative to the NuPhy Console created by reverse-engineering the keyboards' USB protocol.";
        license = licenses.gpl3Only;
        homepage = "https://github.com/donn/nudelta";
        changelog = "https://github.com/donn/nudelta/blob/main/Changelog.md";
        platforms = lib.intersectLists platforms.x86_64 platforms.linux;
        mainProgram = "nudelta";
      };
    } in writeScriptBin "cura" ''
      #! ${pkgs.bash}/bin/bash
      # AppImage version of Cura loses current working directory and treats all paths relateive to $HOME.
      # So we convert each of the files passed as argument to an absolute path.
      # This fixes use cases like `cd /path/to/my/files; cura mymodel.stl anothermodel.stl`.
      args=()
      for a in "$@"; do
        if [ -e "$a" ]; then
          a="$(realpath "$a")"
        fi
        args+=("$a")
      done
      exec "${cura5}/bin/cura5" "''${args[@]}"
    '')
    ...

