module Sources
  module Table
    class Demo < Sources::Table::Base

      def get(options = {})
        path = Rails.application.routes.url_helpers.new_api_chef_comment_path(:format => :js)
        { :columns => ["Name", "Last comment", "IP addr"],
          :rows => [ ["node01", "[by ancor](#{path}) at 10/10/10: not working", "192.168.1.1"],
                     ["node02", "by james at 10/10/11: whatever", "192.168.1.2"] ]
        }
      end

    end
  end
end
