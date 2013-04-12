# Wrapper for the connection object to Chef.
#
# For example, to get a list of all nodes in Chef, execute:
#
#   Chef.node.all
#
# See http://rubydoc.info/gems/ridley for details.

module Chef

  KEY_HEADER = '-----BEGIN RSA PRIVATE KEY-----'
  KEY_FOOTER = '-----END RSA PRIVATE KEY-----'

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
      return @@conn if defined?(@@conn)
      setup_client_key_for_heroku
      @@conn = Ridley.new(
        server_url:  Settings.chef.server_url,
        client_name: Settings.chef.client_name,
        client_key:  Settings.chef.client_key
      )
    end

    # Ridley must take a file path for the client_key, but there's no nice way
    # to push this file to Heroku without public exposure.
    # So let's pass the entire _contents_ of the key as a Heroku config
    # variable, just like the other keys, and write it to disk if this is the
    # case. The newlines are lost due to rails_config + YAML, so we need to
    # reconstruct them here.
    def setup_client_key_for_heroku
      return unless Settings.chef.client_key.include?(KEY_HEADER)
      key_file = Rails.root.join('tmp', 'chef-client.pem')
      lines = Settings.chef.client_key.
        gsub(KEY_HEADER, '').
        gsub(KEY_FOOTER, '').
        split(' ')
      lines.unshift KEY_HEADER
      lines <<      KEY_FOOTER
      File.open(key_file, 'w') { |f| f << lines.join("\n") }
      Settings.chef.client_key = key_file
    end

  end
end
