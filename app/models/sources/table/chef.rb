module Sources
  module Table
    class Sources::Table::Chef < Sources::Table::Base

      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::DateHelper
      include ActiveSupport::Benchmarkable

      def logger
        Rails.logger
      end

      def get(options = {})
        path = Rails.application.routes.url_helpers.new_api_chef_comment_path(:format => :js)
        rows = []

        node_names = benchmark('Load node names') do
          Rails.cache.fetch('Chef.node.all', :expires_in => 10.minutes) do
            ::Chef.node.all.map(&:name)
          end
        end

        node_names.each do |node_name|
          node_info = benchmark("Load #{node_name}") do
            Rails.cache.fetch("node_info:#{node_name}", :expires_in => (15+rand(15)).minutes) do
              node = ::Chef.node.find(node_name)
              [ host(node), server_model(node), total_memory(node),
                environment(node), roles(node), uptime(node), comments(node) ]
            end
          end
          rows << node_info
        end

        { columns: [ 'Host', 'Model', 'RAM', 'Environment', 'Chef role(s)',
                     'Uptime', 'Comments' ],
          rows: rows
        }
      end

      private

      def environment(node)
        node.chef_environment.capitalize
      end

      def host(node)
        node.name.chomp('.cluster.xs')
      end

      def comments(node)
        out = ""
        comments = node.normal_attributes.extra.try(:comments)
        last = comments.try(:last)
        if last
          out = "\"#{last.content}\" by #{last.user_id} #{time_ago_in_words(last.created_at)} ago"
        end
        url = Rails.application.routes.url_helpers.new_api_chef_comment_path(
          chef_comment: { node_name: host(node) }, format: :js
        )
        out << "[<img class='comment' src='/assets/comment-new-icon.png'>](#{url})"
      end

      def uptime(node)
        distance_of_time_in_words(node.automatic_attributes.uptime_seconds)
      end

      def roles(node)
        roles = node.automatic_attributes.roles
        roles.delete('base') if roles.size > 1
        roles.join(', ')
      end

      def total_memory(node)
        memory = node.automatic_attributes.memory
        number_to_human_size(memory[:total].to_i/1000*1024**2, precision: 2)
      end

      def server_model(node)
        system = node.automatic_attributes.dmi.system
        brand  = system.manufacturer.gsub('Inc.', '')
        (brand == 'Bochs') ?
          'KVM Virtual Machine' :
          "#{brand} #{system.product_name}"
      end
    end
  end
end
