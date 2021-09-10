# frozen_string_literal: true

class TodoSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :title, :desc, :status, :user_id, :due_date, files: []

  attribute :todo_with_comment do |object|
    comment = object.comments.all
    object.attributes.merge({comments: comment})
  end

end
