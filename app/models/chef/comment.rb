module Chef
  class Comment
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_accessor :node_name, :body

    validate :always_bad

    def initialize(attributes = {})
      unless attributes.nil?
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end
    end

    def persisted?
      false
    end

    def save
      # do the thing with Ridley
      valid?
    end

    protected

    def always_bad
      self.errors.add :body, "One Error"
    end
  end
end
