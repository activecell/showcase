_ = require("underscore")
module.exports = (grunt) ->
  "use strict"
  path = require("path")
  tasksPath = path.resolve __dirname, "../node_modules/grunt-docco-multi/tasks"
  grunt.loadTasks tasksPath
  grunt.registerMultiTask "dc", "Make documentation by docco", ->
    return  if @options().disabled or @data.disabled
    srcPath = path.resolve __dirname, "../lib/"
    options =
      options: _.defaults(@options(),
        layout : "linear"
        output : "docs/"
      )
      docs: _.defaults(@data,
        src: "#{srcPath}/*.coffee"
      )
    grunt.log.writeln "Make documentation by docco", @data
    grunt.config.set "docco", options
    grunt.task.run ["docco"]
