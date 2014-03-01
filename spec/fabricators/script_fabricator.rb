Fabricator(:script) do
  name {Faker::Name.name}
  body 'echo "hi"'
  branch
end
