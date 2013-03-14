## Showcase

Basic http server for activecell cleint-side libraries on top of express.
Documentation is still in progress.

## How to use

1. Create package.json and add showcase to dependecies

```json
"depenedncies": {
  "showcase": "git+https://activecell-machine-user:NYVy98BbBb6Lae3DAdfWSLCQ@github.com/activecell/showcase#new"
}
```

2. Create symlinks to vendors and bootstrap script (avoid copy-paste)

`mkdir public && ln -s node_modules/showcase/public/vendor public/vendor`
`ln -s node_modules/showcase/script script`

3. Setup Application & Grunt

**Create folders and files**
`mkdir test && mkdir views && touch views/index.jade && touch views/layout.jade && mkdir src && touch Gruntfile.coffee && touch app.coffee`

Showcase include all necessary grunt plugins.

**Gruntfile.coffee (example)**
```coffee
module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files:
          'tmp/striker.js'     : 'src/striker.coffee'

    docco:
      debug:
        src: ['src/striker.coffee']
        options:
          output: 'public/docs'

    watch:
      scripts:
        files: ['src/**/*.coffee', 'Gruntfile.coffee']
        tasks: ['coffee']

    coffeelint:
      app: ['src/*.coffee', 'src/**/*.coffee']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-docco')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.registerTask('default', ['coffee', 'docco', 'watch'])
```

**app.coffee (example)**
```coffee
app   = require('showcase')(__dirname)
grunt = require('grunt')

app.setup ->
  # Start watcher based on grunt
  grunt.tasks('default')

  # Add your custom routes here and add views to /views
  app.get '/', (req, res) ->
    res.render 'index'
```
