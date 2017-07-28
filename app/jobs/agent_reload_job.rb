class AgentReloadJob
  include SuckerPunch::Job

  def perform(data)
    logger.debug "Reload the agent"
    logger.debug "===> #{%x(ruby bin/agent_restart.rb)}"
    TweetlyJob.set_status false
  end
end
