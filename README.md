# TypeScript-Demo-Lib

[![pipeline status](https://gitlab.com/MatrixAI/open-source/TypeScript-Demo-Lib/badges/master/pipeline.svg)](https://gitlab.com/MatrixAI/open-source/TypeScript-Demo-Lib/commits/master)

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

### Calling Executables

When calling executables in development, use this style:

```
npm run typescript-demo-lib -- p1 p2 p3
```

The `--` is necessary to make `npm` understand that the parameters are for your own executable, and not parameters to `npm`.

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

### Path Aliases

Due to https://github.com/microsoft/TypeScript/issues/10866, you cannot use path aliases without a bundler like Webpack to further transform the generated JavaScript code in order to resolve the path aliases. Because this is a simple library demonstration, there's no need to use a bundler. In fact, for such libraries, it is far more efficient to not bundle the code.

However we have left the path alias configuration in `tsconfig.json`, `jest.config.js` and in the tests we are making use of the `@` alias.

### Docs Generation

Remember to create `gh-pages` as an orphan branch first: `git checkout --orphan gh-pages`.

```sh
typedoc --out /tmp/docs src
git checkout gh-pages
find . -mindepth 1 -maxdepth 1 ! -name ".git" -exec rm -r "{}" \;
mv /tmp/docs/* .;
touch .nojekyll
git commit -am "Updated Docs";
git push
```

See the docs at: https://matrixai.github.io/TypeScript-Demo-Lib/

### Publishing

```sh
# npm login
npm version patch # major/minor/patch
npm run build
npm publish --access public
git push
git push --tags
```
