{ pkgs ? import ./pkgs.nix {} }:

with pkgs;
pkgs.mkShell {
  nativeBuildInputs = [
    nodejs
    nodePackages.node2nix
    dpkg
    fakeroot
    rpm
    wineWowPackages.full
    mono
  ];
  shellHook = ''
    echo 'Entering Typescript-Demo-Lib'
    set -o allexport
    . ./.env
    set +o allexport
    set -v

    export PATH="$(pwd)/dist/bin:$(npm bin):$PATH"
    npm install
    mkdir --parents "$(pwd)/tmp"

    set +v
  '';
}
