{
  stdenvNoCC,
  requireFile,
}:

stdenvNoCC.mkDerivation {
  pname = "hytale-server";
  version = "2026.01.15";

  src = requireFile {
    name = "HytaleServer.jar";
    hash = "sha256-GVPs6sHn5hDqs0OHDCgL1egW0Gcyo1CXFKF40KaXXNo=";
    message = ''
      The Hytale server cannot be downloaded automatically.
      Please download it manually:

      1. Run the official Hytale launcher and extract the server, OR
      2. Use the official download script from Hytale

      After obtaining HytaleServer.jar, add it to the Nix store:
        nix-store --add-fixed sha256 HytaleServer.jar

      Or using nix-prefetch-url:
        nix-prefetch-url --type sha256 file:///path/to/HytaleServer.jar
    '';
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java/hytale-server

    cp $src $out/share/java/hytale-server/hytale-server.jar

    runHook postInstall
  '';
}
