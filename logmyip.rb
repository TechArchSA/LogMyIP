#
# Log consultant's IP during engagement
# KING SABRI | @KINGSABRI
#
require 'open-uri'
require 'fileutils'
require 'logger'
require 'libnotify'

if ARGV.size.zero?
  puts "[!] #{__FILE__} < /log/directory/path/ >"
  exit 0
else
  Process.setproctitle("LogMyIP")
  @wait           = 60 * 10    # Check My IP each (default: 10 minuts)
  path            = File.expand_path(ARGV[0], File.dirname(__FILE__))
  @log_path       = "#{path}/logmyip"
  FileUtils.mkdir_p(@log_path) unless Dir.exist?(@log_path)
  
  #
  #-> Loggers setup
  #
  # Service Logs
  @logger_service = Logger.new("#{@log_path}/logmyip.log", 'daily', 30)  # Daily rotation, keep 30 days rotations
  @logger_service.datetime_format = '%Y-%m-%d | %H:%M:%S'
  @logger_service.formatter = proc { |s, d, p, m| "[#{d} | #{s}] #{m}" }
  # IP logs
  @logger_ip = Logger.new("#{@log_path}/ip.log", 'daily', 30)
  @logger_ip.level = Logger::INFO
  @logger_ip.datetime_format = '%Y-%m-%d | %H:%M:%S'
  @logger_ip.formatter = proc { |s, d, p, m| "[#{d}] #{m}" }
  
  # Setup desktop notification
  @notify = Libnotify.new(:icon_path => :"network-wired-activated", :timeout => 5, :urgency => :critical)
end

def logmyip(wait)
  
  tries ||= 20
  ips = []
  begin
    
    loop do
      ip = open('https://api.ipify.org').read
      @logger_service.debug("IP Check!\n")
      unless ips.last == ip
        @logger_ip.info("#{ip}\n")
        @notify.update(:summary => "<h5>LogMyIP | IP Updated!</h5>", :body => "<strong>#{ip}</strong>")
      end
      ips << ip
      sleep wait
    end
    
  rescue SystemExit, Interrupt
    @logger_service.debug("Shutting down #{__FILE__}.\n")
    @notify.update(:summary => "<h5>LogMyIP | Service</h5>", :body => "<strong>Shutting down...</strong>")
  rescue SocketError => e
    
    if (tries -= 1) > 0
      @logger_service.error("#{e.message}\n")
      @notify.update(:summary => "<h5>LogMyIP | Service</h5>", :body => "<strong>Connection refused!</strong>")
      sleep @wait
      retry
    else
      @logger_service.fatal("Too many connection failure | Shutting down #{__FILE__}.\n")
      @notify.update(:summary => "<h5>LogMyIP | Service</h5>", :body => "<strong>Connection refused!<br>Shutting down</strong>")
      exit 0
    end
      
  rescue IOError => e
    @logger_service.error("#{e.message}\n")
    @notify.update(:summary => "<h5>LogMyIP | Service</h5>", :body => "<strong>IOError</strong>")
  rescue Exception => e
    @logger_service.fatal("#{e.message}\n")
    @logger_service.fatal(e.backtrace.join("\n"))
    @notify.update(:summary => "<h5>LogMyIP | Service</h5>", :body => "<strong>Unknown error</strong>")
  end
  
end

logmyip(@wait)
