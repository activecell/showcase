## For installing grunt locally to your project run in console: npm install grunt --save-dev
## This is template gruntfile, which allow use grunt plugins from showcase into your project.
##
## List of plugins:
## gh-pages           - allow push files from "base" directory to github into gh-pages
## docco              - generate docs from your source file
## coffee             - compile *.coffee files to js
## sass               - compile *.scss files to css
## styleguide         - generate styleguide page from your *.scss files and *.hbs
## copy               - can copy files from src folder to dst folder
## clean              - allow remove some files and folders
## symlink            - create symlinks on folder
## compile-handlebars - generate html files from hbs templates
## watch              - watch for files and make a grunt commands if files was changes.
##
## Just uncomment code below and put it to gruntfile in your project
##
#module.exports = (grunt) ->
#  grunt.initConfig
#    pkg: grunt.file.readJSON("package.json")
#      #    allow push files from "base" directory to github into gh-pages. Run: grunt gh-pages
#      "gh-pages":
#        options:
#          base: "#{__dirname}/ghpages"                    # from will be push your files
#          branch: "gh-pages"                              # in this branch
#          repo: "git@github.com:yourepo.git"              # there you can point link to your repo
#        ghp:
#          disabled: no                                    # in future, you can disable this tasks there
#          src: ["**/*"]                                   # all folders and files will be pushed from "base" directory
#
#      generate docs from your source file
#        options:
#          layout : "parallel"                             # you can choose between "parallel" and "linear"
#          output : "ghpages/docs/"                        # output folder
#          timeout: 1000                                   # timeout for async
#        docs:
#          disabled: no                                    # in future, you can disable this tasks there
#          src: "src/coffee/**/*.coffee"                   # what should be doccoed (your src files)
#
#      #    compile *.coffee files to js Run: grunt coffee
#      coffee:
#        options:
#          disable: no
#        compileJoined:
#          options:
#            join: true                                              # if true, will cancatenate your coffee files to one js file
#          files:                                                    # there you describe in which .js file your .coffee files will be compiled
#            "ghpages/js/yourfilename.js": "src/coffee/**/*.coffee"  # all *.coffee files from "src/coffee" will be compiled to "ghpages/js/yourfilename.js"
#            "ghpages/js/example.js": "src/index.coffee"             # "src/index.coffee" will be compiled to "ghpages/js/example.js"
#            "ghpages/js/yourfilename2.js": [                        # file1.coffee and file2.coffee from test/list/ will be compiled to "ghpages/js/yourfilename2.js"
#              "test/list/file1.coffee"
#              "test/list/file2.coffee"
#              ]
#
#
##      #    compile *.scss files to css Run: grunt sass
#      sass:
#        name:                                                       #subtask
#          options:                                                        #options
#            outputStyle: 'expanded'
#          files:
#            'dst/css/name.css': 'src/scss/name.scss'#   # dst:src
#
#      #    watch for files and make a grunt commands if files was changes. Run: grunt watch
#      watch:
#        coffee:
#          files: [                                       # list of files which can be updated
#            "src/**/*.coffee"                            #
#            "test/**/*.coffee"
#          ]
#          tasks: ["coffee"]                              # task which will be make when files will be updated
#        sass:
#          files: ["src/scss/tactile"]
#          tasks: ["sass"]
#
#      #    NOT Grunt plugin - generate styleguide page from your *.scss files and *.hbs. Run: grunt styleguide
#      styleguide:
#        options:
#          markdown: false
#          base: "#{__dirname}/"               # path to root folder for your project
#          name: "styleguide"                  # filename of .hbs template for styleguide page
#        files:
#          templatepath: "views/examples/"     # path to hbs template
#          scsssrc: "src/scss/"                # path to scss files
#          srcname: "tactile.scss"             # name of scss file which will used for generating of styleguide
#          sections: "views/sections/"         # path to hbs sections template
#          dstpath: "ghpages/"                 # path to output dir
#
#      # can copy files from src folder to dst folder. Run: grunt copy
#      copy:
#        main:
#          files: [
#            expand: true, cwd: "src/examples/list/", src: ["*.coffee"], dest: "ghpages/examples/"
#          ]
#
#      # create symlinks on folders. See examples below. Run: grunt symlink
#      symlink:
#        fonts: #subtask
#          src: 'node_modules/showcase/vendor/fonts/'   # src folder
#          dest: 'ghpages/fonts'                        # dst folder
#        images:
#          src: 'node_modules/showcase/vendor/images/'
#          dest: 'ghpages/images'
#        vendor:
#          src: 'node_modules/showcase/vendor/'
#          dest: 'ghpages/vendor'
#
#      # create html pages from your handlebars templates. See examples below. Run: grunt compile-handlebars
#      "compile-handlebars":
#        index:                                                                             #name of subtask
#          template: "views/layout.hbs"                                                     #filename of hbs template
#          templateData: {body: "EmptyPage"}                                                # data for hbs template, can insert it manually
#          output: "ghpages/index.html"                                                     # output filename
#
#        home:
#          template: "{{{datablock}}}"                                                      #you can write template manually
#          templateData: {datablock: "EmptyPage"}                                           #data also
#          output: "ghpages/home.html"
#        performance:                                                                       #make a empty page
#          template: "{{{empty}}}"
#          templateData: {empty: ""}
#          output: "ghpages/performance.html"
#
#      #   allow remove some files and folders
#      clean: ["path/to/dir/one", "path/to/dir/two", "path/to/file.ext"]
#
#      #    There you can group above tasks as you want. See examples.
#      grunt.registerTask "compile-assets", [        #grunt compile-assets - will used coffee and sass task
#        "coffee"
#        "sass"
#      ]
#      grunt.registerTask "compile-docs", [          #grunt compile-docs  - will used docco task
#        "docco"
#      ]
#
#      grunt.registerTask "compile-styleguide", [    #grunt compile-styleguide - will used styleguide task
#        "styleguide"
#      ]
#
#      grunt.registerTask "default", [               #grunt or grunt default - task by default.Just write your tasks which you want to use by default
#        "compile-assets"
#        "compile-docs"
##        "copy"
#        "symlink"
#        "compile-handlebars"
#        "compile-styleguide"
#        "gh-pages"
#        "watch"
#      ]
#      grunt.loadNpmTasks "showcase"                 # load grunt plugins from showcase/tasks directory