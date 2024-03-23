{
  lib,
  nodejs,
  ffmpeg,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  gtk3,
  libayatana-appindicator,
}:
rustPlatform.buildRustPackage rec {
  pname = "stremio-service";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2gVbRYOJBiUjYofQiNMMDilx6GHrbQHWuRu65b1cZSY=";
  };

  server = fetchurl {
    url = "https://dl.strem.io/server/v4.20.3/desktop/server.js";
    sha256 = "sha256-YtoQG8ppBVpe86DjyRKhDwmHhVRYpIOkEDuH21YseWA=";
  };

  # postInstall = ''
  #   mkdir -p $out/{bin,share/applications}
  #   ln -s $out/opt/stremio/stremio $out/bin/stremio
  #   mv $out/opt/stremio/smartcode-stremio.desktop $out/share/applications
  #   install -Dm 644 images/stremio_window.png $out/share/pixmaps/smartcode-stremio.png
  #   ln -s ${nodejs}/bin/node $out/opt/stremio/node
  #   ln -s $server $out/opt/stremio/server.js
  #   wrapProgram $out/bin/stremio \
  #     --suffix PATH ":" ${lib.makeBinPath [ ffmpeg ]}
  # '';

  postInstall = ''
    mkdir -p $out/{bin,share/applications}
    ln -s ${nodejs}/bin/node $out/bin/stremio-runtime
    ln -s ${ffmpeg}/bin/ffmpeg $out/bin/ffmpeg
    ln -s ${ffmpeg}/bin/ffprobe $out/bin/ffprobe
    ln -s $server $out/bin/server.js
    install -Dm 644 resources/com.stremio.service.desktop $out/share/applications/com.stremio.service.desktop
  '';
  # postInstall = ''
  # mkdir -p $out/bin

  cargoBuildFlags = ["--offline"];
  buildFeatures = ["offline-build" "bundled"];
  doCheck = false;
  cargoCheckFeatures = ["offline-build" "bundled"];
  cargoHash = "sha256-GdmNPLRNnpbyNPutb6+TDLRKWXf9g/28UAs6ZilB7N8=";
  # cargoSha256 = "sha256-pVehxYM+tNYdtqx/cAVHPGVYeCorIA3SpUXdl0Lyfu0=";
  buildInputs = [gtk3 openssl];
  nativeBuildInputs = [pkg-config libayatana-appindicator];
  meta = with lib; {
    description = "A companion app for Stremio Web";
    homepage = "https://github.com/Stremio/stremio-service";
    license = licenses.gpl2;
    # maintainers = [];
  };
}
