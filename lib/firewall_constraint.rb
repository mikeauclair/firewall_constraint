module FirewallConstraint
  require 'ipaddress'
  class Constraint
    cattr_accessor :config

    def initialize(ips = [])
      if ips.respond_to? :call
        @ips = ips
      else
        ips = [ips].flatten.compact
        @ips = !ips.empty? ? ips :
          [YAML.load_file(Rails.root.join('config','firewall_constraint.yml'))[Rails.env]].flatten.compact
      end
    end

    def requestor_ip(request)
      request.env["HTTP_X_FORWARDED_FOR"] ? request.env["HTTP_X_FORWARDED_FOR"].split(/, /).first : request.remote_ip
    end

    def matches?(request)
      return true if parsed_ips.empty?
      client_ip = IPAddress::parse requestor_ip(request)
      parsed_ips.each do |ip|
        begin
          return true if ip.include?(client_ip)
        rescue NoMethodError => nme
        end
      end
      raise config.raise_exception if config && config.raise_exception
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
  
  class Config
    attr_accessor :raise_exception
  end
  
  def self.new(*args)
    Constraint.new(*args)
  end
  
  def self.config
    if block_given?
      c = Constraint.config || Config.new
      yield c
      Constraint.config = c
    else
      Constraint.config
    end
  end
end
