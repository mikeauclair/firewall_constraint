module FirewallConstraint
  require 'ipaddress'
  class Constraint
    def initialize(ips = [])
      if ips.respond_to? :call
        @ips = ips
      else
        ips = [ips].flatten.compact
        @ips = !ips.empty? ? ips :
          [YAML.load_file(Rails.root.join('config','firewall_constraint.yml'))[Rails.env]].flatten.compact
      end
    end

    def matches?(request)
      return true if parsed_ips.empty?
      client_ip = IPAddress::parse(request.env["HTTP_X_FORWARDED_FOR"] ? request.env["HTTP_X_FORWARDED_FOR"] : request.remote_ip)
      parsed_ips.each do |ip|
        begin
          return true if ip.include?(client_ip)
        rescue NoMethodError => nme
        end
      end
      false
    end

    def parsed_ips
      cur_ips = ips
      if cur_ips == @old_ips
        @cached_parsed_ips
      else
        @old_ips = cur_ips
        @cached_parsed_ips = cur_ips.map{|c| IPAddress::parse(c)}
      end

    end

    def ips
      @ips.respond_to?(:call) ? @ips.call : @ips
    end
  end

  def self.new(*args)
    Constraint.new(*args)
  end
end
