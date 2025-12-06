# Zed editor feature - binary release from GitHub
# High-performance, multiplayer code editor from the creators of Atom and Tree-sitter
{ pkgs, lib, ... }:
let
  version = "0.212.5";

  zedBinaryPackage =
    {
      stdenv,
      fetchurl,
      autoPatchelfHook,
      makeWrapper,
      alsa-lib,
      fontconfig,
      libxkbcommon,
      mesa,
      openssl,
      vulkan-loader,
      wayland,
      libGL,
      xorg,
      zlib,
    }:
    stdenv.mkDerivation {
      pname = "zed-editor";
      inherit version;

      src = fetchurl {
        url = "https://github.com/zed-industries/zed/releases/download/v${version}/zed-linux-x86_64.tar.gz";
        sha256 = "sha256-cya+wQcj+4VveLuTYm/7pqhvR89qYQnAyGQNhLsk/4M=";
      };

      nativeBuildInputs = [
        autoPatchelfHook
        makeWrapper
      ];

      buildInputs = [
        alsa-lib
        fontconfig
        libxkbcommon
        mesa
        openssl
        vulkan-loader
        wayland
        libGL
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
        zlib
      ];

      installPhase =
        let
          runtimeDeps = [
            wayland
            libxkbcommon
            libGL
            vulkan-loader
          ];
        in
        ''
          runHook preInstall

          mkdir -p $out/bin $out/libexec
          cp -r * $out/libexec/

          makeWrapper $out/libexec/bin/zed $out/bin/zed \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"

          runHook postInstall
        '';

      meta = with lib; {
        description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
        homepage = "https://zed.dev";
        license = licenses.agpl3Plus;
        platforms = [ "x86_64-linux" ];
        mainProgram = "zed";
      };
    };
in
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.callPackage zedBinaryPackage { };
  };
}
