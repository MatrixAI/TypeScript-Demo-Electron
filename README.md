# TypeScript-Demo-Electron

[![pipeline status](https://gitlab.com/MatrixAI/open-source/TypeScript-Demo-Electron/badges/master/pipeline.svg)](https://gitlab.com/MatrixAI/open-source/TypeScript-Demo-Electron/commits/master)

---
**Notice!**
Need to use umask 022. Not umask 027.

Otherwise fakeroot fails.

---
**Webpack Configuration**

The main is the `electronMain`, this compiles the node-side or "main" of electron.

The `electronRenderer` is the frontend side. This is similar to the SPA application. With style loader and stuff.

---
**Electron Forge Configuration**

We are using `@electron-forge/cli` to build the electron apps for different platforms. The configuration can be found in `forge.config.js`.

It includes a list of [makers](https://www.electronforge.io/config/makers).

It also has `packageConfig`, which defines `electronZipDir`, which is the location for the cached electron binaries for different platforms. This gets used during the `nix-build` phase, as `nix` building is done in an offline environment, and requires caching ensure the required binaries used by `electron-forge` are present.

---

## Installation


Building the package:

```sh
nix-build -E '(import ./pkgs.nix {}).callPackage ./default.nix {}'
```

Building the releases:

```sh
nix-build ./release.nix --attr application
nix-build ./release.nix --attr docker
# Platform specific releases:
# LINUX
nix-build ./release.nix --attr package.linux.x64.deb
nix-build ./release.nix --attr package.linux.x64.rpm
nix-build ./release.nix --attr package.linux.x64.zip
# WINDOWS
nix-build ./release.nix --attr package.windows.x64.exe
nix-build ./release.nix --attr package.windows.x64.zip
# DARWIN
nix-build ./release.nix --attr package.darwin.x64.zip
```

Install into Nix user profile:

```sh
nix-env -f ./release.nix --install --attr application
```

Install into Docker:

```sh
# Not Tested Currently
docker load --input "$(nix-build ./release.nix --attr docker)"
```

## Development

Run `nix-shell`, and once you're inside, you can use:

```
# install (or reinstall packages from package.json)
npm install
# build the development dist and watch for file changes
npm run watch
# build the production dist
npm run build
# run the repl (this allows you to import from ./src)
npm run ts-node
# run the tests
npm run test
# lint the source code
npm run lint
# automatically fix the source
npm run lintfix
```

### Using the REPL

```
$ npm run ts-node
> import fs from 'fs';
> fs
> import { Library } from '@';
> Library
> import Library as Library2 from './src/lib/Library';
```

You can also create test files in `./src`, and run them with `npm run ts-node ./src/test.ts`.

This allows you to test individual pieces of typescript code and it makes it easier when doing large scale rearchitecting of TypeScript code.
