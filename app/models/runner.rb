Bundler.with_clean_env do
  Dir.chdir "/other/bundler/project" do
    `bundle exec ./script`
  end
end