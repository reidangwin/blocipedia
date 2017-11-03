class User < ApplicationRecord
  has_many :wikis, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :shared_wikis, through: :collaborators, source: :wiki

  after_initialize :init

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  enum role: [:standard, :premium, :admin]

  def init
    self.role||= :standard
  end

  def upgrade
    update_attribute(:role, :premium )
  end

  def downgrade
    update_attribute(:role, :standard)
  end
end
