module Api
  module Chef
    class CommentsController < ApplicationController
      respond_to :json, :js

      def new
        @chef_comment = ::Chef::Comment.new(params[:chef_comment])
      end

      def create
        @chef_comment = ::Chef::Comment.new(params[:chef_comment])
        @chef_comment.save
        respond_with @chef_comment do |format|
          format.js { render(@chef_comment.valid? ? "create" : "new") }
        end
      end
    end
  end
end
