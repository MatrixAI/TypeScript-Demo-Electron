const process = require('process');
const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { VueLoaderPlugin } = require('vue-loader');
const TsConfigPathsPlugin = require('tsconfig-paths-webpack-plugin');

const electronMain = {
  mode: process.env.production ? 'production' : 'development',
  target: 'electron-main',
  entry: { index: './src/main/index.ts' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.ts?$/,
        loader: 'ts-loader',
        options: {
          appendTsSuffixTo: [/\.vue$/]
        }
      },
      {
        test: /\.css$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          'css-loader',
        ]
      },
      {
        test: /\.(png|svg|jpg|gif|woff|woff2|eot|ttf|otf)$/,
        use: [
          'file-loader'
        ]
      }
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      __static: `"${path.resolve(__dirname, 'dist', 'static')}"`
    }),
  ],
  resolve: {
    extensions: ['.js', '.ts', '.tsx', '.jsx', '.json'],
    plugins: [
      // required to load tsconfig.json for path aliases
      new TsConfigPathsPlugin()
    ]
  },
};

const electronRenderer = {
  mode: process.env.production ? 'production' : 'development',
  target: 'electron-renderer',
  entry: { renderer: './src/renderer/index.ts' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js' // resolves to "renderer.js"
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        use: 'vue-loader'
      },
      {
        test: /\.ts?$/,
        loader: 'ts-loader',
        options: {
          appendTsSuffixTo: [/\.vue$/]
        }
      },
      {
        test: /\.css$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          'css-loader',
        ]
      },
      {
        test: /\.(png|svg|jpg|gif|woff|woff2|eot|ttf|otf)$/,
        use: [
          'file-loader'
        ]
      }
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      // configure global feature flags for vue esm-bundler
      __VUE_OPTIONS_API__: true,
      __VUE_PROD_DEVTOOLS__: false
    }),
    new HtmlWebpackPlugin({
      template: './src/renderer/index.html'
    }),
    new MiniCssExtractPlugin({
      filename: 'index.css'
    }),
    new VueLoaderPlugin(),
  ],
  resolve: {
    extensions: ['.js', '.ts', '.tsx', '.jsx', '.json'],
    plugins: [
      // required to load tsconfig.json for path aliases
     new TsConfigPathsPlugin()
    ]
  },
};

module.exports = [
  electronMain,
  electronRenderer
];
