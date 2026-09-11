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
stdenv.mkDerivation (finalAttrs: {
  pname = "fremont-hw-support";
  version = "20260807.1";

  src = {
    owner = "duckysocks22";
    repo = "fremont-hw-support";
    rev = "fremont-${finalAttrs.version}";
    hash = "sha256-WXn37xArjWR9PJYWClgpJ1K1bpWQ0ivlBaqjAvAqZ6E=";
  };
  
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
})
