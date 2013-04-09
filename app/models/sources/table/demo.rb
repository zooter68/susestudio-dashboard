module Sources
  module Table
    class Demo < Sources::Table::Base

      def get(options = {})
        { :columns => ["Name", "Last comment", "IP addr"],
          :rows => [ ["node01", "by ancor at 10/10/10: not working", "192.168.1.1"],
                     ["node02", "by james at 10/10/11: whatever", "192.168.1.2"] ]
        }
      end

    end
  end
end
