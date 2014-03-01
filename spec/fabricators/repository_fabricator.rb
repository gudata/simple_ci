Fabricator(:repository) do
  name 'Greg Graffin'

  before_create do
    repository_path = Git::create_new_repository(Dir.mktmpdir(nil, Dir.tmpdir()))
    git = Git.new(repository_path)

    git.change_file 'first_file'
    git.commit_file 'first_file', 'first commit in master'
    git.change_file 'first_file'
    git.commit_file 'first_file', 'second commit in master'

    git.change_file 'second_file'
    git.commit_file 'second_file', 'third commit in master'

    self.path = repository_path
  end
end
