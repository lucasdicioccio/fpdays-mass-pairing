{ cabal, array, comonad, gloss }:

cabal.mkDerivation (self: {
  pname = "fpdays-mass-pairing";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ comonad gloss ];
  meta = {
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
