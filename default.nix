{ mkDerivation, base, stdenv, vector, random }:
mkDerivation {
  pname = "streamstats";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base vector random ];
  homepage = "https://github.com/ublubu/streamstats";
  description = "streaming statistics";
  license = stdenv.lib.licenses.unfree;
}
