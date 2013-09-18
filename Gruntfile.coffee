# TODO: unit tests as for each grunt plugin
# TODO: Marina's 2 links on hipchat (assets, css, etc.)

module.exports = (grunt) ->

  grunt.loadTasks("tasks")
  grunt.loadNpmTasks "grunt-gh-pages"
  grunt.loadNpmTasks "grunt-docco-multi"

  grunt.initConfig

    pkg: grunt.file.readJSON("package.json")

    # FIXME: requires to create gh-pages brunch manually
    ghpages:
      options:
        base: "public/ghpages/"
      ghp:
        disabled: yes
      demo:
        dest: "**/*"


    dc:
      options:
        layout : "linear"
      docs:
        disabled: yes
      demo:
        output : "demo/docs/"
        src: ['lib/*.coffee']

#    casper:
#      options:
#        async:
#          parallel: false
#      files: ["tests/casperjs/**/*.js"]
#
  grunt.registerTask "demo", ["ghpages", "dc"]
