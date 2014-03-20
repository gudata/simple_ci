class StateBehaviour
  attr_reader :branch

  def initialize token
    @branch = Branch.find_by(token: token)
  end

  def href
    [@branch.repository, :builds]
  end

  def state_string
    return 'invalid token' unless @branch

    last_build = @branch.tip_commit.last_build

    return 'unknown' unless last_build

    last_build.state_name
  end

end