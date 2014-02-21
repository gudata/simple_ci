class Git
  def initialize path
    @repository_path = path
  end

  class << self
    #
    # Init repository
    #
    # @return String path to the create repository
    def create_new_repository repository_path
      execute = ::Git.new(repository_path)
      execute.init
      repository_path
    end
  end

  def git_executable
    @git_executable ||= Cliver.detect('git')
  end

  def execute command
    cmd = "cd #{@repository_path}; #{git_executable} #{command}"
    puts cmd
    `#{cmd}`
  end


  def init
    execute "init ."
  end

  def change_file name, relative_path = ''
    path = File.join(@repository_path, relative_path)
    file_path = File.join(path, name)
    puts "changing #{file_path}"
    File.open(file_path, "w") {|f| f.write(rand(999999)) }
  end

  def commit_file file_path, message
    execute "add #{file_path}"
    execute "commit -m \"#{message}\""
  end

  def switch_branch branch_name
    execute "checkout -b #{branch_name}"
  end
end
