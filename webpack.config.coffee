webpack = require 'webpack'
module.exports =
  entry: './coffee/vendor.coffee'
  output:
    filename: './tmp/vendor.js'
  resolve:
    extensions: ['', '.js', '.coffee']
  module:
    loaders: [
      test: /\.coffee$/, loader: 'coffee-loader'
    ]
  plugins: [
    new webpack.optimize.UglifyJsPlugin()
  ]
