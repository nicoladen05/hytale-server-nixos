final: prev: {
  lib = prev.lib.extend (_: _: {
    mkContainer = import ../helpers/mkContainer.nix { lib = prev.lib; };
  });
}
