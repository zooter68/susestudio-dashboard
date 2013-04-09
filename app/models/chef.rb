# Wrapper for the connection object to Chef.
#
# For example, to get a list of all nodes in Chef, execute:
#
#   Chef.node.all
#
# See http://rubydoc.info/gems/ridley for details.

module Chef
  class << self

    def method_missing(m, *args, &block)
      if conn.respond_to? m
        conn.send(m, *args, &block)
      else
        super
      end
    end

    private

    def conn
      @@conn ||= Ridley.new(
        server_url:  Settings.chef.server_url,
        client_name: Settings.chef.client_name,
        client_key:  Settings.chef.client_key
      )
      @@conn
    end

  end
end
