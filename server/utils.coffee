module.exports = class Utils

  config: require './config'

  fs: require 'fs'
  jade: require 'jade'
  spawn: require("child_process").spawn
  parallel: require('async').parallel

  getSections: (sections, cb) ->
    jadeDir = "#{__dirname}/../examples/views/sections/"
    for section in sections
      section.data.filename = 'tables.scss'
      section.data.description = section.data.description
        .replace(/\n/g, "<br />")
      jade = null
      try
        jadePath = "#{jadeDir}#{section.reference()}.jade"
        jade = @fs.readFileSync jadePath
      if jade
        locals =
          section: section
          className: '$modifier'
        html = @jade.compile(jade, {pretty: true})(locals)
        section.data.example = html
        for modifier in section.modifiers()
          a = {className: modifier.className()}
          modifier.data.example = @jade.compile(
            jade,
            {pretty: true}
          )(a)
    cb sections if cb

  getDirs: (dirs,cb)->
    async = []
    for dir in dirs
      ((dir)=>
        async.push (done)=>
          @_getFiles dir,done
      )(dir)
    @parallel async, (err,result)=>
      _result = @_serialize result
      cb _result if cb


  _getFiles: (dir,done)->
    @fs.readdir dir, (err,files)=>
      dirs = []
      result = []
      if files and files[0]
        for file in files
          if file.split('.')[1]
            result.push dir+'/'+file
          else
            dirs.push dir+'/'+file
        if dirs[0]
          async = []
          for dir in dirs
            ((dir)=>
              async.push (_done)=>
                @_getFiles dir,_done
            )(dir)
          @parallel async, (err,_result)=>
            #console.log result
            __result = @_serialize _result
            for __res in __result
              result.push __res
            done null,result
        else
          done null,result
      else
        done null,result

  _serialize: (arr)->
    result = []
    for el in arr
      if typeof el is 'object'
        _result = @_serialize el
        for _el in _result
          result.push _el
      else
        result.push el
    result
