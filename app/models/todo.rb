# frozen_string_literal: true

class Todo < ApplicationRecord  
  #Association
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many_attached :files, dependent: :destroy

  #Validation
  validates :title, presence: true

  validates :status, inclusion: { in: ['not-started', 'in-progress', 'complete'] }

  STATUS_OPTIONS = [
    ['Not started', 'not-started'],
    ['In progress', 'in-progress'],
    ['Complete', 'complete']
  ]

  def readable_status
    case status
    when 'not-started'
      'Not started'
    when 'in-progress'
      'In progress'
    when 'complete'
      'Complete'
    end
  end

  def color_class
    case status
    when 'not-started'
      'primary'
    when 'in-progress'
      'info'
    when 'complete'
      'success'
    end
  end

end
