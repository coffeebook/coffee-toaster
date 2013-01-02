class Cli

  # requires
  optimist = require 'optimist'

  constructor:->
    usage = "#{'CoffeeToaster'.bold}\n"
    usage += "  Minimalist build system for CoffeeScript\n\n".grey
    
    usage += "#{'Usage:'}\n"
    usage += "  toaster [#{'options'.green}] [#{'path'.green}]\n\n"
    
    usage += "#{'Examples:'}\n"
    usage += "  toaster -n myawsomeapp   (#{'required'.red})\n"
    usage += "  toaster -i [myawsomeapp] (#{'optional'.green})\n"
    usage += "  toaster -d [myawsomeapp] (#{'optional'.green})\n"
    usage += "  toaster -c [myawsomeapp] (#{'optional'.green})\n"
    usage += "  toaster -ca [myawsomeapp] (#{'optional'.green})\n"
    usage += "  toaster -w [myawsomeapp] (#{'optional'.green})\n"
    usage += "  toaster -wc [myawsomeapp] (#{'optional'.green})"
    usage += "  toaster -wd [myawsomeapp] (#{'optional'.green})"
    usage += "  toaster -wdc [myawsomeapp] (#{'optional'.green})"
    
    @argv = (@opts = optimist.usage( usage )
      .alias('n', 'new')
      .describe('n', "Scaffold a very basic new App")
      
      .alias('i', 'init')
      .describe('i', "Create a config (toaster.coffee) file")
      
      .alias('w', 'watch')
      .describe('w', "Start watching/compilin in the given mode.")
      
      .alias('c', 'compile')
      .describe('c', "Compile in release mode (all js files merged).")

      .alias('d', 'debug')
      .describe('d', 'Compile in debug mode (compile js files individually)')

      .alias('a', 'autorun')
      .describe('a', 'Execute the script in node.js after compilation')

      .alias('j', 'config')
      .string( 'j' )
      .describe('j', "Config file formatted as a json-string.")

      .alias( 'f', 'config-file' )
      .string( 'f' )
      .describe('f', "Path to a different config file.")

      .alias('v', 'version')
      .describe('v', '')

      .alias('h', 'help')
      .describe('h', '')
    ).argv