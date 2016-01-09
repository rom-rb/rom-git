require 'rugged'

require 'rom'
require 'rom/git/gateway'
require 'rom/git/relation'

ROM.register_adapter(:git, ROM::Git)
