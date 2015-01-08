require "test_helper"
require "anima"

class Commit
  include Anima.new(:sha1, :message, :committer)
end

describe "Git Adapter" do
  let(:path) { File.expand_path("./test/fixtures") }

  def setup
    setup = ROM.setup("git://#{path}", branch: 'refs/heads/master')

    setup.schema do
      base_relation(:commits) do
        repository :default

        attribute "sha1"
        attribute "message"
        attribute "committer"
      end
    end

    setup.relation(:commits) do
      def by_committer(committer_name)
        find_all { |row| row[:committer] == committer_name }
      end

      def find_commit(sha1)
        find_all { |row| row[:sha1] == sha1 }
      end
    end


    setup.mappers do
      define(:commits) do
        model Commit
      end
    end
    setup
  end

  subject { s = setup; s.finalize }

  describe "env#read" do
    it "returns mapped object" do
      commit = subject.read(:commits).by_committer("Franck Verrot").to_a.first

      assert_equal '101868c4ce62b7e96a1f7c3b64fa40285ee00d5e', commit.sha1
      assert_equal 'commit (initial): Initial commit', commit.message
      assert_equal 'Franck Verrot', commit.committer
    end
  end

  describe "dataset#header" do
    it "returns the header defined in the schema" do
      assert_equal %w(sha1 message committer), subject.relations.commits.header
    end
  end

  describe "relation" do
    it "finds a specific commit by its sha1" do
      sha1 = 'fe326fd5cb986e6ef3d83f02857fb5bc10333aa4'

      commit = subject.read(:commits).find_commit(sha1).to_a.first

      assert_equal sha1,              commit.sha1
      assert_equal 'commit: Add bar', commit.message
      assert_equal 'Franck Verrot',   commit.committer
    end
  end
end
