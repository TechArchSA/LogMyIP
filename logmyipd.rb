require 'daemons'

def status(app)
  # Display the default status information
  app.default_show_status
end

options =
    {
      :app_name   => 'LogMyIP',
      :backtrace  => true,
      :show_status_callback => :status
    }

Daemons.run(File.expand_path("logmyip.rb"), options)
