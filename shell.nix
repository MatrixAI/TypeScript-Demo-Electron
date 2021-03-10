{ pkgs ? import ./pkgs.nix {} }:

with pkgs;
let
  utils = callPackage ./utils.nix {};
in
  pkgs.mkShell {
    nativeBuildInputs = [
      nodejs
      nodePackages.node2nix
      # electron is also installed in package.json because of electron-forge
      # electron-forge demands this
      # but we make nix electron priority
      electron
      nodePackages."@electron-forge/cli"
      # debian builds
      dpkg
      fakeroot
      # rpm builds
      rpm
      # exe builds
      wineWowPackages.full
      mono
      # zip builds
      zip
    ];
    # prevent electron download from electron in package.json
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # use the electron builds from here
    electron_zip_dir = utils.electronZipDir;
    shellHook = ''
      echo 'Entering Typescript-Demo-Electron'
      set -o allexport
      . ./.env
      set +o allexport
      set -v

      export PATH="${electron}/bin:$(pwd)/dist/bin:$(npm bin):$PATH"
      npm install
      mkdir --parents "$(pwd)/tmp"

      # force 022 when using fakeroot
      umask 022

      set +v
    '';
  }
