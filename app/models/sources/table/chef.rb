module Sources
  module Table
    class Sources::Table::Chef < Sources::Table::Base

      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::DateHelper

      def get(options = {})
        path = Rails.application.routes.url_helpers.new_api_chef_comment_path(:format => :js)
        rows = []
        count = 1
        ::Chef.node.all.each do |node|
          node.reload
          rows << [ host(node), server_model(node), total_memory(node),
                    roles(node), uptime(node), kernel(node), comments(node) ]

          # FIXME It's too slow to display all nodes now, so just do the first 10
          break if count > 10

          count += 1
        end

        { columns: [ 'Host', 'Model', 'RAM', 'Chef role(s)', 'Uptime',
                     'Kernel', 'Comments' ],
          rows: rows
        }
      end

      private

      def host(node)
        node.name.chomp('.cluster.xs')
      end

      def kernel(node)
        node.automatic_attributes.kernel.release
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
