require "test_helper"

describe "Git Gateway" do
  let(:path) { File.expand_path("./test/fixtures") }
  let(:rom_setup) do
    ROM.setup(
      commits: [
        :git,
        path,
        branch: 'refs/heads/master'
      ]
    )
  end

  before do
    ROM.plugins do
      adapter :git do
        register :test_plugin, Module.new, type: :relation
      end
    end
  end

  describe "relation with plugin" do
    it "shouldn't raise error" do
      rom_setup.relation(:commits) do
        gateway :commits
        use :test_plugin
      end
    end
  end
end
