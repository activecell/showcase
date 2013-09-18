_ = require("underscore")
module.exports = (grunt) ->
  "use strict"
  path = require("path")
  tasksPath = path.resolve __dirname, "../node_modules/grunt-casperjs/tasks"
  grunt.loadTasks tasksPath
  grunt.registerMultiTask "casper", "Make test by casperjs", ->
    return  if @options().disabled
    srcPath = path.resolve __dirname, "../lib/"
    options =
      options: _.defaults(@options(),
        layout : "linear"
        output : "docs/"
      )
      docs: _.defaults(@data,
        src: "#{srcPath}/*.coffee"
      )
    grunt.log.writeln "test", @data
    grunt.config.set "casper", options
#    grunt.task.run ["docco"]
