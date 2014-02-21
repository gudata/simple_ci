yatoto = Fabricate(:repository, name: 'yatoto')

execute = Execute.new(yatoto.path)
execute.switch_branch 'second_branch'
execute.change_file 'hello_branch'
execute.commit_file 'hello_branch', 'first in second_branch'

yatoto.open
yatoto.refresh_branches

Branch.find_each do |branch|
  script = branch.scripts.build
  script.body = 'echo "hello world"'
  script.save
end
repository = Repository.create([{ name: 'Club50plus' }])