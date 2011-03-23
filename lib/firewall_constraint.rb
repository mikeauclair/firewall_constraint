module FirewallConstraint
  require 'ipaddress'
  class Constraint
    def initialize(ips = [])
      @config = ips.empty? ? 
        YAML.load_file(Rails.root.join('config','firewall_constraint.yml'))[Rails.env] :
        ips

      @ips = @config.map{|c| IPAddress::parse(c)}
    end

    def matches?(request)
      client_ip = IPAddress::parse(request.env["HTTP_X_FORWARDED_FOR"] ? request.env["HTTP_X_FORWARDED_FOR"] : request.remote_ip)
      @ips.each do |ip|
        begin
          return true if ip.include?(client_ip)
        rescue NoMethodError => nme
        end
      end
      false
    end
  end
  # Your code goes here...
end
