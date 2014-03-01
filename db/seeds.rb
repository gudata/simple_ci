yatoto = Fabricate(:repository, name: 'Photo blog', auto_fetch: true, fetch_interval: 1)

execute = Git.new(yatoto.path)
execute.switch_branch 'second_branch'
execute.change_file 'hello_branch'
execute.commit_file 'hello_branch', 'first in second_branch'

yatoto.open
yatoto.refresh_branches
# yatoto.refresh_all_commits

Branch.find_each do |branch|
  script = branch.scripts.build
  script.name = "Tests"
  script.body = <<-BASH
echo "Hello world"
  BASH

  script.save
end
Branch.first.update_attribute(:build, true)

repository = Repository.create([{ name: 'Emptyness' }])
