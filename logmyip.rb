#
# Log consultant's IP during engagement
# KING SABRI | @KINGSABRI
#
require 'open-uri'
require 'logger'

if ARGV.size.zero?
  puts "[!] #{__FILE__} < /log/directory/path/ >"
  exit 0
else
  Process.setproctitle("LogMyIP")
  @wait           = 3600 * 3    # Check My IP each (default: 1 hour)
  path            = File.expand_path(ARGV[0], File.dirname(__FILE__))
  @log_path       = "#{path}/logmyip"
  Dir.mkdir(@log_path) unless Dir.exist?(@log_path)
  
  #
  # Loggers setup
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
end

def logmyip(wait)
  
  tries ||= 20
  
  begin
    
    loop do
      ip = open('https://api.ipify.org').read
      @logger_ip.info("#{ip}\n")
      sleep wait
    end
    
  rescue SystemExit, Interrupt
    @logger_service.debug("Shutting down #{__FILE__}.")
  rescue SocketError => e
    
    if (tries -= 1) > 0
      @logger_service.error("#{e.message}\n")
      sleep @wait
      retry
    else
      @logger_service.fatal("Too many connection failure | Shutting down #{__FILE__}.")
      exit 0
    end
      
  rescue IOError => e
    @logger_service.error("#{e.message}\n")
  rescue Exception => e
    @logger_service.fatal("#{e.message}\n")
    @logger_service.fatal(e.backtrace.join("\n"))
  end
  
end

logmyip(@wait)