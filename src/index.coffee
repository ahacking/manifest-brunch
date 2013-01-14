sysPath = require 'path'
fs = require 'fs'
util = require 'util'

module.exports = class CacheManifestBuilder
  brunchPlugin: yes

  constructor: (@config) ->
    @path = sysPath.join @config.paths.public, 'cache.manifest'
    Object.freeze this

  onCompile: (generatedFiles) ->
    re = /\n# Compilation time: [TZ\d\-:.]+\n/
    compilationTime = "\n# Compilation time: #{new Date().toISOString()}\n"
    fs.exists @path, (exists) =>
      return unless exists
      fs.readFile @path, (error, buffer) =>
        return console.log error if error?
        data = buffer.toString()
        newData = if data.match(re)
          data.replace(re, compilationTime)
        else
          data + compilationTime
        fs.writeFile @path, newData, (error) =>
          return console.log error if error?
