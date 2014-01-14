{print} = require 'util'
{spawn} = require 'child_process'
node_path = '/home/jazz/dev/node-v0.10.13-linux-x64'
jade = node_path + '/bin/jade'


task 'jade:index', 'Build src/index.jade to public', ->
  compile({file: "src/index.jade"})

option '-f', '--file [file]', 'compile jade'
task 'jade:compile', 'Build public/ from src/', (options)->
  compile(options)

compile = (options) ->
  coffee = spawn jade, ['-P',options.file,'-o',"public/"]
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0



