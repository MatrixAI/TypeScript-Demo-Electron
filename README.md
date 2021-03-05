# TypeScript-Demo-Electron

[![pipeline status](https://gitlab.com/MatrixAI/open-source/TypeScript-Demo-Electron/badges/master/pipeline.svg)](https://gitlab.com/MatrixAI/open-source/TypeScript-Demo-Electron/commits/master)

## Installation

Note that JavaScript libraries are not packaged in Nix. Only JavaScript applications are.

Building the package:

```sh
nix-build -E '(import ./pkgs.nix).callPackage ./default.nix {}'
```

Building the releases:

```sh
nix-build ./release.nix --attr application
nix-build ./release.nix --attr docker
```

Install into Nix user profile:

```sh
nix-env -f ./release.nix --install --attr application
```

Install into Docker:

```sh
docker load --input "$(nix-build ./release.nix --attr docker)"
```

## Development

Run `nix-shell`, and once you're inside, you can use:

```sh
# install (or reinstall packages from package.json)
npm install
# build the dist
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
