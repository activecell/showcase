_ = require("underscore")

kss = require "kss"
fs  = require "fs"
handlebars = require "handlebars"


module.exports = (grunt) ->
  "use strict"
  path = require("path")
  coffeePath  = path.resolve __dirname, "../node_modules/grunt-contrib-coffee/tasks"
  copyPath    = path.resolve __dirname, "../node_modules/grunt-contrib-copy/tasks"
  compassPath = path.resolve __dirname, "../node_modules/grunt-contrib-compass/tasks"
  doccoPath   = path.resolve __dirname, "../node_modules/grunt-docco-multi/tasks"
  ghpagesPath = path.resolve __dirname, "../node_modules/grunt-gh-pages/tasks"
  watchPath   = path.resolve __dirname, "../node_modules/grunt-contrib-watch/tasks"
  cleanPath   = path.resolve __dirname, "../node_modules/grunt-contrib-clean/tasks"

  grunt.loadTasks coffeePath
  grunt.loadTasks copyPath
  grunt.loadTasks compassPath
  grunt.loadTasks doccoPath
  grunt.loadTasks ghpagesPath
  grunt.loadTasks watchPath
  grunt.loadTasks cleanPath

  grunt.registerMultiTask "styleguide", "compiled styleguide with hbs", () ->
    done = this.async()
    data = this.data
    options = this.options()

    #generate there styleguide page
    kss.traverse options.base+data.scsssrc, { markdown: options.markdown }, (err, styleguide) ->
      return console.log(err) if err
      sections = require('showcase').getSections(data.srcname, options.base+data.sections, styleguide)
      source = fs.readFileSync(options.base+ data.templatepath + options.name + ".hbs").toString()
      template = handlebars.compile(source);
      html = template(sections: sections)
      fs.writeFileSync(options.base + data.dstpath + options.name + ".html", html)
      done()
