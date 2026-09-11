{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "fremont-hw-support-source";
  version = "20260807.1";

  src = fetchFromGitHub {
    owner = "duckysocks22";
    repo = "fremont-hw-support";
    rev = "fremont-${version}";
    hash = "sha256-WXn37xArjWR9PJYWClgpJ1K1bpWQ1ivlBaqjAvAqZ6E=";
  };

  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    cp -r . $out
  '';
}
