class AgentReloadJob
  include SuckerPunch::Job

  def perform(data)
    puts "Reload the agent"
    puts "===> #{%x(ruby bin/agent_restart.rb)}"
    TweetlyJob.set_status false
  end
end
