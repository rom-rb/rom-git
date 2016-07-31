require 'rom/relation'
require 'rom/plugins/relation/key_inference'
require 'rom/plugins/relation/view'

module ROM
  module Git
    class Relation < ROM::Relation
      adapter :git

      forward :join, :project, :restrict, :order

      use :view
      use :key_inference

      def count
        dataset.count
      end
    end
  end
end
