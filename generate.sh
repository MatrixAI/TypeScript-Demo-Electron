tmpdir="node2nix-generated-expressions"
mkdir -p "$tmpdir/dev"
mkdir -p "$tmpdir/prod"
nodeVersion=$(node --version | sed 's/^v\([0-9]*\).*/\1/')
node2nix \
  --development \
  --input package.json \
  --lock package-lock.json \
  --node-env "$tmpdir/dev/node-env.nix" \
  --output "$tmpdir/dev/node-packages.nix" \
  --composition "$tmpdir/dev/default.nix" \ \
  --nodejs-$nodeVersion
node2nix \
  --input package.json \
  --lock package-lock.json \
  --node-env "$tmpdir/prod/node-env.nix" \
  --output "$tmpdir/prod/node-packages.nix" \
  --composition "$tmpdir/prod/default.nix" \
  --nodejs-$nodeVersion
