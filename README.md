# TypeScript-Demo-Electron

[![pipeline status](https://gitlab.com/MatrixAI/open-source/TypeScript-Demo-Electron/badges/master/pipeline.svg)](https://gitlab.com/MatrixAI/open-source/TypeScript-Demo-Electron/commits/master)

---

Need to use umask 022. Not umask 027.

Otherwise fakeroot fails.

Need to integrate webpack into electron here as well.

Needed `@electron-forge/plugin-webpack`.

```
npm install --save-dev @electron-forge/plugin-webpack
```

This gives us a typescript-webpack template. I need to inspect the template to compare what we are trying to do.

```
mkdir -p tmp/webpacky
cd tmp/webpacky
electron-forge init --template=typescript-webpack
```

This creates several webpack files:

```
webpack.main.config.js
webpack.plugins.js
webpack.renderer.config.js
webpack.rules.js
```

The main is the `electronMain`, this compiles the node-side or "main" of electron.

The `webpack.renderer.config.js` is the frontend side. This is similar to the SPA application. With style loader and stuff. It has a rules.

A common set of rules is `webpack.rules`.

The rules are things that test for stuff and use certain loaders.

What is `fork-ts-checker-webpack-plugin`.




---

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
