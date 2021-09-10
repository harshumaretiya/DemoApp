# frozen_string_literal: true
class UserSession < ApplicationRecord
  # relations
  belongs_to :user

  # Validations
  validates :platform, inclusion: { in: %w[web ios android admin] }
end
