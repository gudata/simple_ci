Fabricator(:repository) do
  name 'Greg Graffin'

  before_create do
    repository_path = Git::create_new_repository(Dir.mktmpdir(nil, Dir.tmpdir()))
    execute = Git.new(repository_path)

    execute.change_file 'first_file'
    execute.commit_file 'first_file', 'first commit in master'
    execute.change_file 'first_file'
    execute.commit_file 'first_file', 'second commit in master'


    self.path = repository_path
  end
end
