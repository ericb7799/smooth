/**
 * @see http://webpack.github.io/docs/configuration.html
 * for webpack configuration options
 */
var webpack = require("webpack");

module.exports = {
  context: __dirname,

  entry: {
    client: "./src/client.coffee",
    inspector: "./src/inspector.cjsx"
  },

  output: {
    path: __dirname + "/dist",
    filename: "[name].js",
    library: ["Smooth","[name]"],
    libraryTarget: "umd",
    publicPath: "/smooth-developer-tools/"
  },

  resolve: {
    extensions: ["",".js",".coffee",".cjsx",".scss",".html"],
    modulesDirectories: [
      'node_modules', 
      'bower_components'
    ],
  },

  plugins: [
    new webpack.ProvidePlugin({
      "_": "underscore",
      "Backbone": "backbone",
      "React": "react"
    }) 
  ],

  externals:{
    "jquery": "var jQuery",
    "$"     : "var jQuery"
  },

  // The 'module' and 'loaders' options tell webpack to use loaders.
  // @see http://webpack.github.io/docs/using-loaders.html
  module: {
    loaders: [
      { test: /\.coffee$/, loaders: ["coffee-loader"] },
      { test: /\.cjsx$/, loaders: ["coffee-loader","cjsx-loader"] },
      { test: /\.scss$/, loader: "style!css!sass?outputStyle=expanded"},
      { test: /\.css$/, loader: "style!css!sass?outputStyle=expanded"},
      {test: /\.(jpg|png|gif|svg)/, loader: 'file-loader?path=smooth-developer-tools'},
      {test: /\.(eot|ttf|woff)/, loader: 'file-loader?path=smooth-developer-tools'}
    ]
  }
};
