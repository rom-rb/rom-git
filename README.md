# ROM::Git [![Travis](https://secure.travis-ci.org/franckverrot/rom-git.png)](http://travis-ci.org/franckverrot/rom-git)
Minimal Git support for [Ruby Object Mapper](https://github.com/rom-rb/rom).
Currently only supports reading from the repository.


## Installation

Add this line to your application's Gemfile:

    gem 'rom-git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rom-git

Alternatively, you can spawn a `pry` console right away by just running:

    $ rake console


## Usage

### Set up the adapter, relation and mapper

```ruby
setup = ROM.setup("git://path/to_some_git_repo", branch: 'refs/heads/master')

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
    model (Class.new do
      include Anima.new(:sha1, :message, :committer)
    end)
  end
end
setup
end

rom = setup.finalize
```

### Find commits by committer

```ruby
commit = rom.read(:commits).by_committer('Franck Verrot').to_a.first

commit.sha1      # => '101868c4ce62b7e96a1f7c3b64fa40285ee00d5e'
commit.message   # => 'commit (initial): Initial commit'
commit.committer # => 'Franck Verrot'
```


### Get a relation's attributes

```ruby
rom.relations.commits.header # => %w(sha1 message committer)
```


### Find a commit by its SHA1

```ruby
sha1 = 'fe326fd5cb986e6ef3d83f02857fb5bc10333aa4'
commit = subject.read(:commits).find_commit(sha1).to_a.first

commit.sha1      # => sha1
commit.message   # => 'commit: Add bar'
commit.committer # => 'Franck Verrot'
```

## Contributing

1. Fork it ( https://github.com/franckverrot/rom-git/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT License - Copyright 2015 Franck Verrot
See LICENSE.txt for details.
