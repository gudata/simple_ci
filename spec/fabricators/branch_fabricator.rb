Fabricator(:branch) do
  name {Faker::Name.name}
  repository
end
