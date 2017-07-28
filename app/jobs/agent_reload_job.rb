class AgentReloadJob
  include SuckerPunch::Job

  def perform(data)
    Rails.logger.debug "Reload the agent"
    Rails.logger.debug "===> #{%x(bin/agent_restart.rb)}"
    TweetlyJob.set_status false
  end
end
