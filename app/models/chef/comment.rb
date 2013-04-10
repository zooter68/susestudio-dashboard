module Chef
  class Comment
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_accessor :node_name, :body

    validate :not_blank

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
      node = Chef.node.find("#{node_name}.cluster.xs")
      last = node.normal_attributes.extra.try(:comments).try(:last)
      if last
        past = node.normal_attributes.extra.try(:comments).try(:past)
        past ||= []
        past.unshift(last)
        node.set_chef_attribute('extra.comments.past', past)
      end
      node.set_chef_attribute('extra.comments.last', {
        user_id:    'admin',
        created_at: Time.now.iso8601,
        content:    body
      })
      node.save
    end

    protected

    def not_blank
      if body.blank?
        errors.add :body, 'Please fill in the comment'
      end
    end
  end
end
