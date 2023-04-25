const { type } = require("os");
const path = require("path");
const webpack = require('webpack');

module.exports = {
    entry: {
        bundle: './src/bundle.js'
    },
    module: {
      rules: [
        {
          test: /\.tsx?$/,
          use: 'ts-loader',
          exclude: ["/node_modules/", "/src/waveform-playlist/" ], 
        },
        {
          test: /\.css$/,
          use: [
            'style-loader',
            'css-loader'
          ]
        },
        {
          test: /\.html$/,
          type: 'asset/source'
        },
      ],
    },
    plugins: [
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery'
      })
    ],
    resolve: {
      extensions: ['.tsx', '.ts', '.js', '.css', '.html'],
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].js'
    },
    node: {
      global: true
    }

  };