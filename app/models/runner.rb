class Runner
  def initialize
    puts 'Runner started'
  end

  # Goes in infinite loop checking for something to build
  def start
    loop do
      puts 'Waiting for builds'
      runonce
      sleep 5
    end
  end

  def refresh_repositories
    Repository.find_each do |repository|
      puts "Refresh repository #{repository.path}"
      unless repository.auto_fetch
        puts " - skipping because it is not marked with auto fetch"
        next
      end

      if repository.auto_fetch and repository.last_fetch and (repository.last_fetch + repository.fetch_interval.seconds) > Time.now
        puts " - skipping because it is too early to fetch"
        next
      end

      puts " - Fetching new commits and branches..."
      repository.refresh_all_commits
      repository.update_attribute(:last_fetch, Time.now)
    end
  end

  def runonce
    if running?
      puts "There is a build running. Wait or stop it."
    else
      refresh_repositories

      if build = Build.newest.pending.in_active_branch.first
        run build
      else
        puts "Everthing is builded...going to sleep"
      end
    end
  end

  def running?
    Build.where(state: Build::States[:running]).exists?
  end

  def run(build)
    Thread.abort_on_exception = true

    puts "#{Time.now.to_s} | Build #{build.id} started.."

    threads = []
    build.branch.scripts.each_with_index do |script, index|
      threads << Thread.new(build, script) do
        fix_pool
        puts "Starting script #{index} - #{script.name}"
        script.run(build)
      end
    end
    threads.each { |thr| thr.join }
  end

  def fix_pool
    Rails.application.config.after_initialize do
      ActiveRecord::Base.connection_pool.disconnect!
      ActiveSupport.on_load(:active_record) do
        config = ActiveRecord::Base.configurations[Rails.env]
        config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
        config['pool']              = ENV['DB_POOL']      || 5
        ActiveRecord::Base.establish_connection(config)
      end
    end
  end

end