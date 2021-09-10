# frozen_string_literal: true

class Comment < ApplicationRecord
  #Association
  belongs_to :user
  belongs_to :todo

  #Validation
  validates :body, presence: true
end
