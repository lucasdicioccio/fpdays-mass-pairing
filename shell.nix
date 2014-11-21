{ }:

with import <nixpkgs> {};
let haskellPackages = pkgs.haskellPackages.override {
      extension = self: super: {
        fpDays = self.callPackage ./. { };
      };
    };
in lib.overrideDerivation haskellPackages.fpDays (attrs: {
     buildInputs = [ haskellPackages.cabalInstall ] ++ attrs.buildInputs;
   })
