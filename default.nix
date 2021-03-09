{ runCommandNoCC
, electron
, writeShellScriptBin
, callPackage
}:

let
  utils = callPackage ./utils.nix {};
  drv = runCommandNoCC
    utils.node2nixDev.name
    {
      version = utils.node2nixDev.version;
      packageName = utils.node2nixDev.packageName;
    }
    ''
    mkdir -p $out/lib/node_modules/${utils.node2nixDev.packageName}
    # copy only the dist
    cp -r ${utils.node2nixDev}/lib/node_modules/${utils.node2nixDev.packageName}/dist $out/lib/node_modules/${utils.node2nixDev.packageName}/
    # copy over the production dependencies
    cp -r ${utils.node2nixProd}/lib/node_modules $out/lib/node_modules/${utils.node2nixDev.packageName}/
    # create symlink to the deployed executable folder, if applicable
    if [ -d "${utils.node2nixDev}/lib/node_modules/.bin" ]; then
      cp -r ${utils.node2nixDev}/lib/node_modules/.bin $out/lib/node_modules/
      ln -s $out/lib/node_modules/.bin $out/bin
    fi
    '';
  drvWrapper = (
    writeShellScriptBin utils.basename
    ''
    exec ${electron}/bin/electron ${drv}/lib/node_modules/${drv.packageName}/dist "$@"
    ''
  ).overrideAttrs(attrs: {
    name = "${attrs.name}-${drv.version}";
    version = drv.version;
  });
in
  drvWrapper
