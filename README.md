```
  _________.__
 /   _____/|  |__   ______  _  __ ____ _____    ______ ____
 \_____  \ |  |  \ /  _ \ \/ \/ // ___\\__  \  /  ___// __ \
 /        \|   Y  (  <_> )     /\  \___ / __ \_\___ \\  ___/
/_______  /|___|  /\____/ \/\_/  \___  >____  /____  >\___  >
        \/      \/                   \/     \/     \/     \/

          Bad-ass infrastructure for javascript libraries.
```

## How to install

```json
"dependencies": {
  "showcase": "~0.2.0"
}
```

## How to use

### Well configured express server for documentation, tests and so on

It uses [express](http://expressjs.com/), so you can extend it as you like. Check default [configuration](https://github.com/activecell/showcase/blob/master/lib/index.coffee)

```coffee
app = require('showcase').app(__dirname)
app.get '/', (req, res) ->
  res.render 'examples/index'

app.start()
```

### Easy authentication with github

```coffee
app = require('showcase').app(__dirname)
app.configure 'production' ->
  app.set('github-client-id', 'id')
  app.set('github-client-secret', 'secret')
```

### Generate documentation with docco

```coffee
docco = require('showcase').docco
docco(files: '/src/*', output: '/public/docs', root: __dirname, layout: 'linear')
```
