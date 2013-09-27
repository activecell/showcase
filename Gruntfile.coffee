module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    #compile css file from scss
    sass:
      styleguide:
        options:
          style: 'expanded'
        files:
          'vendor/css/styleguide.css': 'vendor/scss/styleguide.scss'

    grunt.loadTasks "tasks"