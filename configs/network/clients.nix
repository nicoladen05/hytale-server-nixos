let
  v4prefix = "192.168.2";
in
{
  router = {
    ip = v4prefix + ".1";
  };
  server = {
    ip = v4prefix + ".2";
  };
  nicoPc = {
    ip = v4prefix + ".39";
    mac = "d8:43:ae:29:99:48";
  };
}
