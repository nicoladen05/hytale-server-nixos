let
  networking = import ../../../../configs/network;
  mkWolSwitch =
    {
      name,
      ip,
      mac,
      turn_off ? "",
    }:
    {
      inherit
        mac
        turn_off
        name
        ;
      host = ip;
      platform = "wake_on_lan";
    };
in
{
  default_config = { };

  temperature_unit = "C";
  unit_system = "metric";

  # Wake on lan
  switch = [
    (mkWolSwitch {
      name = "Nico's PC";
      inherit (networking.clients.nicoPc) ip mac;
    })
  ];
}
