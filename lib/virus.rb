require 'daitss/config'

class VirusCheck

  # returns array [ CHECK_PASSED (boolean), SCANNER_OUTPUT ]
  def self.virus_check path
    output = `#{Daitss::CONFIG['virus-scanner-executable']} #{path} 2>&1`
    [ $?.exitstatus == 0, output ]
  end
end
