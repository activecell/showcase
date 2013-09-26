module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
#compile css file from scss
    compass:
      compileJoined:
        options:
          sassDir: 'vendor/scss'                 # path to src directory
          cssDir:  'vendor/css'                  # path to dst folder

    grunt.loadTasks "tasks"