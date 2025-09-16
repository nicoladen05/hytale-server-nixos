final: prev: rec {
  python313 = prev.python313.override {
    packageOverrides = pythonFinal: pythonPrev: {
      pycord = prev.callPackage ../packages/pycord.nix {};
      wavelink = prev.callPackage ../packages/wavelink.nix {};
    };
  };

  python313Packages = python313.pkgs;
}
