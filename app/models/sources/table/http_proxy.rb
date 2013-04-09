#
# Use the "Value Path" setting to select nested value from JSON structure:
#   {
#     "parent" : {
#       "child" : {
#         "child2" : "myValue"
#       }
#     }
#   }
#
# Example: parent.child.nestedChild.value
module Sources
  module Table
    class HttpProxy < Sources::Table::Base
      include HttpProxyResolver

    end
  end
end
