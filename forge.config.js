const process = require('process');

module.exports = {
  packagerConfig: {
    electronZipDir: process.env.electron_zip_dir
  },
  makers: [
    {
      name: '@electron-forge/maker-deb',
    },
    {
      name: '@electron-forge/maker-rpm',
    },
    {
      name: "@electron-forge/maker-squirrel",
      config: {
        authors: "Matrix AI"
      }
    },
    {
      name: '@electron-forge/maker-zip',
    }
  ]
};
