class MainHelper
  class << self
    def get_stage(url)
      (1..3).each do |attempt| #3 attempts
        agent = Mechanize.new
        agent.max_history = 0
        agent.user_agent_alias = "Mac Safari"
        begin
          return agent.get(url) 
        rescue 
          if attempt == 3
            puts '-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#'
            puts "Can't load this page - #{url}"
            puts '-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#'
          end
        end  
      end
      nil
    end
  end
end
