module Sources
  module Number
    class Demo < Sources::Number::Base

      def get(options = {})
        { :value => rand(99) }
      end

    end
  end
end
