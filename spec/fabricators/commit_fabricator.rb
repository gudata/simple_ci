Fabricator(:commit) do
  author { Fabricate(:developer) }
  committer { Fabricate(:developer) }
  branch
end
