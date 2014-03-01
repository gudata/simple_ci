require 'shellwords'
# require 'charlock_holmes/string'

class Script < ActiveRecord::Base
  belongs_to :branch
  has_one :repository, through: :branch
  validates :name, presence: true
  validates :body, presence: true

  def run build
    build.fire_state_event(:mark_running)

    build.repository.work_on_ref(build.commit.oid) do
      Bundler.with_clean_env do
        Dir.chdir repository.path do
          execute_with_bash build
        end
      end
    end
  end


  def make_shellscript body
    script_file = Tempfile.new("shell", binmode: false)
    script_file_path = script_file.path
    script_file.close
    script_file.unlink

    script_file = File.open(script_file_path, "w") do |file|
      file.write(body)
    end
    File::chmod(0700, script_file_path)
    script_file_path
  end

  def execute_with_bash(build)
    puts "running..."
    puts "-"*80
    # escaped_command = ::Shellwords.escape(self.body)
    script_file_path = make_shellscript(self.body)
    tmp_file = Tempfile.new("child-output", binmode: true)
    process = ::ChildProcess.build(Cliver.detect('bash'), '--login', '-c', script_file_path)

    process.io.stdout = tmp_file
    process.io.stderr = tmp_file
    process.cwd = repository.path
    process.environment['CI_SERVER'] = 'yes'
    process.environment['CI_SERVER_NAME'] = 'Simple CI'
    process.environment['CI_BUILD_REF'] = build.commit.oid
    process.environment['CI_BUILD_ID'] = build.id
    process.start

    begin
      process.poll_for_exit(self.timeout)
    rescue ::ChildProcess::TimeoutError
      process.stop # tries increasingly harsher methods to kill the process.
      status = build.fire_state_event(:mark_unknown)
      return false
    end

    if process.exit_code == 0
      status = build.fire_state_event(:mark_success)
      puts "mark as success #{status}"
    else
      status = build.fire_state_event(:mark_failed)
      puts "mark as failed #{status}"
    end

  rescue => e
    status = build.fire_state_event(:mark_unknown)
    puts "mark as unkown #{status}"
    puts e.message.inspect
  ensure
    build.update_attribute(:output, get_output(tmp_file))
    File.unlink(script_file_path)
  end

  def get_output(tmp_file)
    tmp_file.rewind
    output = encode!(tmp_file.read)
    tmp_file.close
    tmp_file.unlink
    output
  end

  def encode!(message)
    return nil unless message.respond_to? :force_encoding

    # if message is utf-8 encoding, just return it
    message.force_encoding("UTF-8")
    return message if message.valid_encoding?

    # return message if message type is binary
    detect = CharlockHolmes::EncodingDetector.detect(message)
    return message if detect[:type] == :binary

    # if message is not utf-8 encoding, convert it
    if detect[:encoding]
      message.force_encoding(detect[:encoding])
      message.encode!("UTF-8", detect[:encoding], undef: :replace, replace: "", invalid: :replace)
    end

    # ensure message encoding is utf8
    message.valid_encoding? ? message : raise

    # Prevent app from crash cause of encoding errors
  rescue
    encoding = detect ? detect[:encoding] : "unknown"
    "--broken encoding: #{encoding}"
  end

end
