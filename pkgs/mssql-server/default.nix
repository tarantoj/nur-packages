{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  gcc,
  libgcc,
  openssl_3,
  libuuid,
  libgccjit,
  krb5,
  systemd,
  pam,
  openldap,
  numactl,
  nss,
  e2fsprogs,
  sssd,
  rpmextract,
  lib,
  fetchzip,
  # libsForQt5,
  # pcsclite,
}:
stdenv.mkDerivation {
  pname = "mssql-server";
  version = "16.0.4165.4-7";

  src = fetchurl {
    url = "https://pmc-prod-afd-endpoint-evdhh8f8byhsezfp.b01.azurefd.net/rhel/9/mssql-server-2022/Packages/m/mssql-server-16.0.4165.4-7.x86_64.rpm";
    hash = "sha256-mccKEssTGERgFBy2nrQGtxqWXiSuZrv7mammfouxtsE=";
  };

  nativeBuildInputs = [
    rpmextract
    autoPatchelfHook
    # libsForQt5.wrapQtAppsHook
  ];

  unpackPhase = ''
    runHook preUnpack

    rpmextract $src

    runHook postUnpack
  '';

  buildInputs = [
    # libsForQt5.qtbase
    # libsForQt5.qtimageformats
    # pcsclite
    libgcc
    (openssl_3.override {enableMD2 = true;})
    libuuid
    libgccjit
    krb5
    systemd
    pam
    openldap
    numactl
    sssd
    e2fsprogs
  ];

  installPhase = ''
    mkdir -p $out/{opt,usr}
    mv opt/* $out/opt
    mv usr/* $out/usr
    # mkdir -p $out/share
    # mkdir -p $out/bin
    # cp -r usr/share/* $out/share
    # mkdir -p $out/share/eidhr
    # cp -r usr/lib/akd/eidmiddleware/* $out/share/eidhr
    # rm -r $out/share/eidhr/{lib,plugins,qt.conf}
    #
    # mkdir -p $out/bin
    # ln -s $out/share/eidhr/Client $out/bin/eidhr-client
    # ln -s $out/share/eidhr/Signer $out/bin/eidhr-signer
    #
    # cp -r etc $out/etc
    # cp -r usr/share/* $out/share
    # sed -i "s|Exec=.*|Exec=eidhr-client|g" $out/share/applications/eidclient.desktop
    # sed -i "s|Exec=.*|Exec=eidhr-signer|g" $out/share/applications/signer.desktop
  '';

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [tarantoj];
    platforms = lib.intersectLists lib.platforms.x86_64 lib.platforms.linux;
  };
}
