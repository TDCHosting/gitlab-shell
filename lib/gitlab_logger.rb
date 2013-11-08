require_relative 'gitlab_config'
require 'syslog/logger';
require 'logger';

config = GitlabConfig.new

def convert_log_level log_level
  Logger.const_get(log_level.upcase)
rescue NameError
  $stderr.puts "WARNING: Unrecognized log level #{log_level.inspect}."
  $stderr.puts "WARNING: Falling back to INFO."
  Logger::INFO
end

if( config.logfile.match(/SYSLOG/) )
then
  $logger = Syslog::Logger.new("gitlab-shell");
else
  $logger = Logger.new(config.log_file)
end

$logger.level = convert_log_level(config.log_level)
