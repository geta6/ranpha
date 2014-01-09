{EventEmitter2} = require 'eventemitter2'

###

Ranpha

- route (method, pattern, gen)
  - get
  - post
  - put
  - patch
  - delete
- rewrite (regex, rewrite)

###


class Ranpha extends EventEmitter2

  koa = require 'koa'
  dbg = require('debug') 'ranpha'
  route = require 'koa-route'
  rewrite = require 'koa-rewrite'

  delimeter: ':'

  constructor: ->
    @app = koa()
    @mod = new RanphaApp()
    return Proxy.create
      get: (proxy, key) =>
        return @[key] if @[key]?
        return @app[key] if @app[key]?
        return undefined

  # interface

  use: (mw, opts = {}) ->
    if typeof mw is 'function'
      @app.use mw
    else
      @app.use @mod[mw] opts

  enable: (mod, opts = {}) ->
    @mod[mod] @app, opts


  listen: (port = 3000) ->
    @app.listen port

  # routing

  route: (method, pattern, generator) ->
    dbg "set route: #{method.toUpperCase()} #{pattern}"
    @app.use route[method] pattern, generator

  get: (pattern, generator) ->
    @route 'get', pattern, generator

  post: (pattern, generator) ->
    @route 'get', pattern, generator

  put: (pattern, generator) ->
    @route 'get', pattern, generator

  patch: (pattern, generator) ->
    @route 'get', pattern, generator

  delete: (pattern, generator) ->
    @route 'get', pattern, generator

  rewrite: (regex, replace) ->
    @app.use rewrite regex, replace



class RanphaApp

  #koa = require 'koa'
  dbg = require('debug') 'ranpha:app'

  constructor: ->
    #Object.defineProperty @, 'app',
    #  enumerable: no
    #  configurable: no

  # middleware

  favicon: (opts) ->
    dbg "use favicon middleware"
    return require('koa-favicon')(opts)

  logger: (opts) ->
    dbg "use logger middleware"
    return require('koa-logger')(opts)

  static: (root, opts) ->
    dbg "use static middleware"
    return require('koa-static')(root, opts)

  session: (opts) ->
    dbg "use session middleware"
    return require('koa-session')(opts)

  # module

  qs: (app) ->
    dbg "enable qs middleware"
    return require('koa-qs')(app)

  csrf: (app, opts = {}) ->
    dbg "enable csrf middleware"
    return require('koa-csrf')(app)



exports = module.exports = ->
  ranpha = new Ranpha
  exports[k] = v for k, v of ranpha.mod
  return ranpha


