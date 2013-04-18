fs  = require('fs')
kss = require('kss')
hbs = require('hbs')

# Generate kss documentation
module.exports = (filename, path, styleguide) ->
  styleguide.section().map (section) ->
    file                     = fs.readFileSync("#{path}/#{section.reference()}.hbs").toString()
    html                     = hbs.compile(file)({className: '$modifier'})
    section.data.filename    = filename
    section.data.description = section.data.description.replace(/\n/g, "<br />")
    section.data.example     = html

    section.modifiers = section.modifiers().map (modifier) ->
      modifier.data.example = hbs.compile(file)(className: modifier.className())
      name: modifier.name()
      description: modifier.description()
    section
