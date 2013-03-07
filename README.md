# Showcase

Common showcase for libraries

## The five-minute setup.

Check your system for local requirements (run until it passes!):

    script/bootstrap

Run tests to ensure that all pass:

    npm test

Run the project locally (with tests and watcher):

    npm start

Then navigate to the [showcase](http://localhost:5000).

## Contributing

To contribute to Showcase, please follow these instructions.

1. Complete the **five-minute setup** above.
1. Create a thoughtfully named topic branch to contain your change
1. Hack away
1. Add tests and make sure everything still passes by running `npm test`
1. If necessary, [rebase your commits into logical chunks](https://help.github.com/articles/interactive-rebase), without errors
1. Push the branch up to GitHub
1. Send a pull request for your branch

**Note: You don't have to fork the project in order to create a branch and a pull request!**

### Hacking on the source

* Source for the library is in src/coffee/
* Tests for the library are in test/
* Showcase files are in examples/public/coffee/

All source code should be documented with [TomDoc](http://tomdoc.org/).

For the showcase, you can either update the existing examples, or create a new example. To create a new example, just create a file in examples/public/coffee/ that demonstrates the functionality, and add the reference in examples/coffee/index.coffee.

#### _Seriously._ For all new source functionality, make sure you have:

1. A pull request that can be merged into master (shows green merge button)
1. Test coverage
1. TomDoc that shows nicely in docco
1. Everything passing using `npm test` (including lint!)
1. Updated showcase for your functionality

### Hacking on design

* Source for our stylesheet is in src/scss/
* Templates for the styleguide sections are in [jade](http://jade-lang.com/) format in examples/views/sections/

All design should be documented with [kss](https://github.com/kneath/kss) and showcased in our style guide. Simply ensure that you have a valid section commented in the source and a corresponding template available.
