{
  python313Packages,
  fetchPypi,
  ...
}:

let
  inherit (python313Packages) buildPythonPackage;
in
buildPythonPackage rec {
  pname = "wavelink";
  version = "3.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CqLbXk59awcCpp5M23FhtEe3pXNZVbzlu62ygjXFR44=";
  };

  build-system = with python313Packages; [
    setuptools
  ];

  dependencies = with python313Packages; [
    aiohttp
    discordpy
    yarl
    typing-extensions
  ];

  # Patch requirements.txt to replace discord.py with py-cord
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "discord.py" "py-cord"

    substituteInPlace requirements.txt \
      --replace "async_timeout" ""
  '';
}
