{
  fpp-config,
  fpp-sd,
  fpp-launcher,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  fetchpatch,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  bluez,
  bzip2,
  cubeb,
  curl,
  ffmpeg,
  fmt_10,
  glib,
  gtk2,
  gtk3,
  gtest,
  hidapi,
  enet,
  libevdev,
  libGL,
  libiconv,
  libpulseaudio,
  libspng,
  libusb1,
  libXdmcp,
  libXext,
  libXi,
  libXrandr,
  lz4,
  lzo,
  mbedtls_2,
  miniupnpc,
  minizip-ng,
  openal,
  pugixml,
  qtbase,
  qtsvg,
  SDL2,
  sfml,
  udev,
  vulkan-loader,
  xorg,
  xxHash,
  xz,
}: let
  rev = "f245e1ee105eeb5c18653657cd8b29415dc37243";
  version = "3.0.5";
in
  stdenv.mkDerivation {
    pname = "project-plus";
    inherit version;

    src = fetchFromGitHub {
      owner = "jlambert360";
      repo = "Ishiiruka";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
      inherit rev;
    };

    patches = [
      fetchpatch
      {
        url = "https://github.com/dolphin-emu/dolphin/commit/3da2e15e6b95f02f66df461e87c8b896e450fdab.patch";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
      }
    ];

    strictDeps = true;

    nativeBuildInputs = [
      cmake
      pkg-config
      wrapQtAppsHook
      copyDesktopItems
    ];
    buildInputs = [
      bzip2
      cubeb
      curl
      enet
      ffmpeg
      fmt_10
      gtest
      hidapi
      libiconv
      libpulseaudio
      libspng
      libXdmcp
      libXi
      lz4
      lzo
      libusb1
      mbedtls_2
      miniupnpc
      minizip-ng
      openal
      pugixml
      qtbase
      qtsvg
      SDL2
      sfml
      xxHash
      xz
      alsa-lib
      bluez
      libevdev
      libGL
      libXrandr
      udev
      vulkan-loader
      libXext
      glib
      gtk2
      gtk3
      xorg.libXinerama
    ];

    cmakeFlags = [
      "-DLINUX_LOCAL_DEV=true"
      "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-3.0/include"
      "-DGTK3_GDKCONFIG_INCLUDE_DIR=${gtk3.out}/lib/gtk-3.0/include"
      "-DGTK3_INCLUDE_DIRS=${gtk3.out}/lib/gtk-3.0"
      "-DENABLE_LTO=True"
      "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
      "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
      "-DGTK2_INCLUDE_DIRS=${gtk2}/lib/gtk-2.0"
    ];

    qtWrapperArgs = [
      "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [vulkan-loader]}"
      "--set QT_QPA_PLATFORM xcb"
    ];

    patchPhase = ''
      sed -i 's|\$\\{GIT_EXECUTABLE} rev-parse HEAD|echo ${rev}|g' CMakeLists.txt # --set scm_rev_str everywhere to actual commit hash when downloaded
      sed -i 's|\$\\{GIT_EXECUTABLE} describe --always --long --dirty|echo FM v${version}|g' CMakeLists.txt # ensures compatibility w/ netplay
      sed -i 's|\$\\{GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD|echo HEAD|g' CMakeLists.txt
      sed -i 's|#include <optional>|#include <optional>\n#include <string>|g' Source/Core/DiscIO/DiscExtractor.h
      cp Externals/wxWidgets3/include/wx Source/Core/ -r
      cp Externals/wxWidgets3/wx/* Source/Core/wx/
    '';

    installPhase = ''
      runHook preInstall

      cp -rf ${fpp-config}/Binaries/* Binaries/
      chmod -R 755 Binaries/
      rm Binaries/portable.txt

      cp -rf ${fpp-launcher}/Launcher/* Binaries/Launcher
      mkdir -p Binaries/User/Wii
      install -D -m 755 ${fpp-sd}/sd.raw Binaries/User/Wii
      mkdir -p $out
      cp Binaries/ $out/ -r

      sed -i 's|ISOPaths = 2|ISOPaths = 1|g' $out/Binaries/User/Config/Dolphin.ini
      sed -i 's|WiiSDCardPath = ./User/Wii/sd.raw|WiiSDCardPath = '$out'/User/Wii/sd.raw|g' $out/Binaries/User/Config/Dolphin.ini
      sed -i 's|ISOPath0 = ./Launcher|ISOPath0 = '$out'/Launcher|g' $out/Binaries/User/Config/Dolphin.ini
      sed -i '\|ISOPath1 = ./Games|d' $out/Binaries/User/Config/Dolphin.ini

      mkdir -p $out/bin
      ln -s $out/Binaries/ishiiruka $out/bin/faster-project-plus

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "project-plus";
        exec = "project-plus";
        icon = "ishiiruka";
        desktopName = "Project+";
        comment = "Ishiiruka fork for SSBPM";
        type = "Application";
        categories = ["Emulator" "Game"];
        keywords = ["ProjectM" "Project M" "ProjectPlus" "Project Plus" "Project+"];
      })
    ];
  }
