class User < ApplicationRecord
  has_many :wikis, dependent: :destroy
  after_initialize :init

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  enum role: [:standard, :premium, :admin]

  def init
    self.role||= :standard
  end
end
