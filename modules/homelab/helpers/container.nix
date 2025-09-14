{ lib, ... }:

{
  name,
  autoStart ? true,
  ...
}@args:

let
  attrs = lib.mergeAttrs { inherit autoStart; } args;
  containerOpts = lib.filterAttrs (n: _: n != "name") attrs;
in
{
  virtualisation.oci-containers.containers."${name}" = containerOpts;
}
