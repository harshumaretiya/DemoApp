# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable

  #Association
  has_one_attached :avatar
  has_many :todos, dependent: :destroy
  has_many :comments, dependent: :destroy

  #Validation
  validates :email, uniqueness: true

  def admin?
    self.role == "admin"
  end

  def name
    "#{first_name} #{last_name}"
  end
end
