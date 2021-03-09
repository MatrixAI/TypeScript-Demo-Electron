{ pkgs ? import ./pkgs.nix {} }:

with pkgs;
let
  utils = callPackage ./utils.nix {};
  buildDeb = arch:
    stdenv.mkDerivation rec {
      name = "${utils.basename}-${version}-linux-${arch}.deb";
      version = utils.node2nixDev.version;
      src = "${utils.node2nixDev}/lib/node_modules/${utils.node2nixDev.packageName}";
      buildInputs = [
        nodejs
        git
        nodePackages."@electron-forge/cli"
        dpkg
        fakeroot
      ];
      electron_zip_dir = utils.electronZipDir;
      buildPhase = ''
        cp ${./package.json} package.json
        cp ${./forge.config.js} forge.config.js
        DEBUG=* electron-forge make \
          --arch ${arch} \
          --platform linux \
          --targets @electron-forge/maker-deb
      '';
      installPhase = ''
        cp out/make/deb/${arch}/*.deb $out
      '';
    };
  buildRpm = arch:
    vmTools.runInLinuxVM (stdenv.mkDerivation rec {
      size = 8192;
      memSize = 2048;
      dontFixup = true;
      name = "${utils.basename}-${version}-linux-${arch}.rpm";
      version = utils.node2nixDev.version;
      src = "${utils.node2nixDev}/lib/node_modules/${utils.node2nixDev.packageName}";
      buildInputs = [
        nodejs
        git
        nodePackages."@electron-forge/cli"
        rpm
      ];
      electron_zip_dir = utils.electronZipDir;
      buildPhase = ''
        set -x
        cp ${./package.json} package.json
        cp ${./forge.config.js} forge.config.js
        DEBUG=* electron-forge make \
          --arch ${arch} \
          --platform linux \
          --targets @electron-forge/maker-rpm
      '';
      installPhase = ''
        cp out/make/rpm/${arch}/*.rpm $out
      '';
    });
  buildExe = arch:
    stdenv.mkDerivation rec {
      name = "${utils.basename}-${version}-win32-${arch}.exe";
      version = utils.node2nixDev.version;
      src = "${utils.node2nixDev}/lib/node_modules/${utils.node2nixDev.packageName}";
      buildInputs = [
        nodejs
        git
        nodePackages."@electron-forge/cli"
        wineWowPackages.full
        mono
      ];
      electron_zip_dir = utils.electronZipDir;
      buildPhase = ''
        # wine needs HOME
        mkdir home
        export HOME="$(realpath home)"
        cp ${./package.json} package.json
        cp ${./forge.config.js} forge.config.js
        DEBUG=* electron-forge make \
          --arch ${arch} \
          --platform win32 \
          --targets @electron-forge/maker-squirrel
      '';
      installPhase = ''
        cp out/make/squirrel.windows/${arch}/*.exe $out
      '';
    };
    buildZip = arch: platform:
    stdenv.mkDerivation rec {
      name = "${utils.basename}-${version}-${platform}-${arch}.zip";
      version = utils.node2nixDev.version;
      src = "${utils.node2nixDev}/lib/node_modules/${utils.node2nixDev.packageName}";
      buildInputs = [
        nodejs
        git
        nodePackages."@electron-forge/cli"
        zip
      ];
      electron_zip_dir = utils.electronZipDir;
      buildPhase = ''
        cp ${./package.json} package.json
        cp ${./forge.config.js} forge.config.js
        DEBUG=* electron-forge make \
          --arch ${arch} \
          --platform ${platform} \
          --targets @electron-forge/maker-zip
      '';
      installPhase = ''
        cp out/make/zip/${platform}/${arch}/*.zip $out
      '';
    };
    buildWinZip = arch:
    stdenv.mkDerivation rec {
      name = "${utils.basename}-${version}-win32-${arch}.zip";
      version = utils.node2nixDev.version;
      src = "${utils.node2nixDev}/lib/node_modules/${utils.node2nixDev.packageName}";
      buildInputs = [
        nodejs
        git
        nodePackages."@electron-forge/cli"
        zip
        wineWowPackages.full
        mono
      ];
      electron_zip_dir = utils.electronZipDir;
      buildPhase = ''
        # wine needs HOME
        mkdir home
        export HOME="$(realpath home)"
        cp ${./package.json} package.json
        cp ${./forge.config.js} forge.config.js
        DEBUG=* electron-forge make \
          --arch ${arch} \
          --platform win32 \
          --targets @electron-forge/maker-zip
      '';
      installPhase = ''
        cp out/make/zip/win32/${arch}/*.zip $out
      '';
    };
in
  rec {
    application = callPackage ./default.nix {};
    docker = dockerTools.buildImage {
      name = application.name;
      contents = [ application ];
      keepContentsDirlinks = true;
      extraCommands = ''
        mkdir -m 1777 tmp
      '';
      config = {
        Cmd = [ "/bin/${utils.basename}" ];
      };
    };
    package = {
      linux = {
        x64 = {
          deb = buildDeb "x64";
          rpm = buildRpm "x64";
          zip = buildZip "x64" "linux";
        };
        ia32 = {
          deb = buildDeb "ia32";
          rpm = buildRpm "ia32";
          zip = buildZip "ia32" "linux";
        };
      };
      windows = {
        x64 = {
          exe = buildExe "x64";
          zip = buildWinZip "x64";
        };
        ia32 = {
          exe = buildExe "ia32";
          zip = buildWinZip "x64";
        };
      };
      darwin = {
        x64 = {
          zip = buildZip "x64" "darwin";
        };
        ia32 = {
          zip = buildZip "ia32" "darwin";
        };
      };
    };
  }
