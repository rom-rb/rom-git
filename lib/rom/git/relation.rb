require 'rom/relation'

module ROM
  module Git
    class Relation < ROM::Relation
      adapter :git

      forward :join, :project, :restrict, :order

      def count
        dataset.count
      end
    end
  end
end
