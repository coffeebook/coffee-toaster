Toast = require './toaster/toast'
Cli = require './toaster/cli'

Project = require './toaster/generators/project'
Config = require './toaster/generators/config'

{log,debug,warn,error} = require './toaster/utils/log-util'

module.exports = class Toaster

  # requirements
  fs = require "fs"
  fsu = require "fs-util"
  path = require "path"
  exec = (require "child_process").exec
  colors = require 'colors'

  @basedir = null
  @options = null 
  @skip_initial_build = false

  # variable - before filter container
  before_build: null

  constructor:( basedir, options = null, skip_initial_build = false )->

    @basedir = basedir
    @options = options
    @skip_initial_build = skip_initial_build

    @basepath = path.resolve( basedir || "." )

    @cli = new Cli options

    # increments basepath if some path is given for args -n, -i, -c, -w, -d
    # just one of these could have a path, so only the first found will be
    # considered.
    for flag in ('nicwd'.split '')
      if (typeof (base = @cli.argv[flag]) is 'string')
        @basepath = path.resolve base
        break

    # injecting options into @cli.argv to maintain interoperability
    if @options?
      @cli.argv[k] = v for k, v of @options

    # printing version
    if @cli.argv.v
      filepath = path.join __dirname, "/../package.json"
      contents = fs.readFileSync filepath, "utf-8"
      schema = JSON.parse contents
      return log schema.version
    
    # scaffolding basic structure for new projects
    else if @cli.argv.n
      new Project( @basepath ).create @cli.argv.n

    # initializing a toaster file template into an existent project
    else if @cli.argv.i
      new Config( @basepath ).create()

    # injecting namespace declarations
    # else if @cli.argv.ns
    #   @toast = new toaster.Toast @
    #   new toaster.misc.InjectNS @toast.builders

    # auto run mode
    # else if @cli.argv.a and not @cli.argv.c
    #   msg = "Option -a can't work without -w, usage: \n"
    #   msg += "\ttoaster -wa"
    #   error msg

    # compile / debug project
    else if (@cli.argv.c or @cli.argv.r or @cli.argv.w or @cli.argv.s)
      @toast = new Toast @
      unless skip_initial_build
        if (@cli.argv.c or @cli.argv.r or @cli.argv.w)
          @build()

    # showing help screen
    else
      return log @cli.opts.help()

  # can be called by apps using toaster as lib, and build the project with
  # options to inject header and footer code which must to be in coffee as well
  # and will be compiled together the app.
  build:( header_code = "", footer_code = "" )->
    for builder in @toast.builders
      if @cli.argv.c? or @cli.argv.w?
        builder.compile header_code, footer_code
      else if @cli.argv.r
        builder.optimize header_code, footer_code

  # resets the toaster completely - specially used when the `toaster.coffee`
  # config file is edited :)
  reset:( options )->
    builder.reset() for builder in @toast.builders
    @options[ key ] = val for val, key of options if options?
    new Toaster @basedir, @options, @skip_initial_build