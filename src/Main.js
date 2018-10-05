"use strict";

var path = require("path");

exports.staticPath = function(folder) {
  return path.join(__dirname, 'public')
}
