_ = require("underscore")
path = require("path")
getPath = (p)->
  path.resolve __dirname, '..', p

console.log 'BASE', getPath("public/ghpages")

module.exports = (grunt) ->
  "use strict"
  path = require("path")
  tasksPath = path.resolve __dirname, "../node_modules/grunt-gh-pages/tasks"
  grunt.loadTasks tasksPath
  grunt.registerMultiTask "ghpages", "Github pages publish", ->
    return  if @options().disabled or @data.disabled
    options =
      options: _.defaults(@options(),
        base: getPath("vendor/")
      )
      ghp: _.defaults(@data,
        src: ["**/*"]
      )
    grunt.log.writeln "Publishing githib pages from", options.options.base
    grunt.config.set "gh-pages", options
    grunt.task.run ["gh-pages"]
