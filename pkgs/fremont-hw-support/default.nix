{ lib
, stdenv
, callPackage
, resholve
, bash
, coreutils
, e2fsprogs
, exfatprogs
, f3
, findutils
, gawk
, gnugrep
, gnused
, jq
, parted
, procps
, systemd
, util-linux
}:

let
  src = callPackage ./src.nix { };
in
stdenv.mkDerivation {
  pname = "fremont-hw-support";

  inherit src;
  inherit (src) version;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fwupd/remotes.d
    cp -r usr/share/fwupd/remotes.d/fremont $out/share/fwupd/remotes.d
    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      SteamOS Hardware Support for the Steam Machine (fremont)
    '';
    license = licenses.unfreeRedistributableFirmware;
  };
}
