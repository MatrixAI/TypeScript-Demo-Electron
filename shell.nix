{ pkgs ? import ./pkgs.nix {} }:

with pkgs;
pkgs.mkShell {
  nativeBuildInputs = [
    nodejs
    nodePackages.node2nix
    electron
    nodePackages."@electron-forge/cli"
    dpkg
    fakeroot
    rpm
    wineWowPackages.full
    mono
  ];
  shellHook = ''
    echo 'Entering Typescript-Demo-Electron'
    set -o allexport
    . ./.env
    set +o allexport
    set -v

    export PATH="$(pwd)/dist/bin:$(npm bin):$PATH"
    npm install
    mkdir --parents "$(pwd)/tmp"

    # needed to use fakeroot
    # otherwise the electron-forge complains
    # umask 022

    set +v
  '';
}
