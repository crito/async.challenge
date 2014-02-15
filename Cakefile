# https://github.com/crito/js.scaffold

# =====================================
# Imports

fsUtil = require('fs')
pathUtil = require('path')

# =====================================
# Variables

WINDOWS       = process.platform.indexOf('win') is 0
NODE          = process.execPath
NPM           = (if WINDOWS then process.execPath.replace('node.exe', 'npm.cmd') else 'npm')
EXT           = (if WINDOWS then '.cmd' else '')
APP_DIR       = process.cwd()
PACKAGE_PATH  = pathUtil.join(APP_DIR, "package.json")
PACKAGE_DATA  = require(PACKAGE_PATH)
SRC_DIR       = pathUtil.join(APP_DIR, "src")
OUT_DIR       = pathUtil.join(APP_DIR, "dist")
TEST_DIR      = pathUtil.join(APP_DIR, "test")
MODULES_DIR   = pathUtil.join(APP_DIR, "node_modules")
BIN_DIR       = pathUtil.join(MODULES_DIR, ".bin")
GIT           = "git"
CAKE          = pathUtil.join(BIN_DIR, "cake#{EXT}")
COFFEE        = pathUtil.join(BIN_DIR, "coffee#{EXT}")
MOCHA         = pathUtil.join(BIN_DIR, "mocha#{EXT}")

# =====================================
# Generic

{exec,spawn} = require('child_process')
safe = (next,fn) ->
  fn ?= next  # support only one argument
  return (err) ->
    # success status code
    if err is 0
      err = null

    # error status code
    else if err is 1
      err = new Error('Process exited with error status code')

    # Error
    return next(err)  if err
    # Continue
    return fn()

finish = (err) ->
  throw err  if err
  console.log('OK')

# =====================================
# Actions

actions =
  clean: (opts,next) ->
    (next = opts; opts = {})  unless next?
    args = ['-Rf', OUT_DIR]
    for path in [APP_DIR, TEST_DIR]
      args.push(
        pathUtil.join(path,  'build')
        pathUtil.join(path,  'components')
        pathUtil.join(path,  'bower_components')
        pathUtil.join(path,  'node_modules')
        pathUtil.join(path,  '*out')
        pathUtil.join(path,  '*log')
      )
    spawn('rm', args, {stdio:'inherit', cwd:APP_DIR}).on('close', safe next)

  test: (opts,next) ->
    (next = opts; opts = {})  unless next?
    args = ['--compilers', 'coffee:coffee-script',
            '--require', 'coffee-script',
            '--require', 'test/test_helper.coffee',
            '--colors',
            '--recursive']
    process.env["NODE_ENV"] = "test"
    spawn(MOCHA, args, {stdio:'inherit', cwd:APP_DIR, env: process.env})
      .on('close', safe next)

  server: (opts, next) ->
    (next = opts; opts = {}) unless next?
    spawn(COFFEE, ['app.coffee'], {stdio: 'inherit', cwd: APP_DIR})
      .on('close', safe next)

# =====================================
# Commands

commands =
  clean:       'clean up instance'
  test:        'run our tests (runs compile)'
  server:      'start the http server'

Object.keys(commands).forEach (key) ->
  description = commands[key]
  fn = actions[key]
  task key, description, (opts) ->  fn(opts, finish)
