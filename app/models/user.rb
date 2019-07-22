class User < ApplicationRecord
  # site is only optional in the case of a facebook signup, where
  # it redirects you and forces you to choose a site
  belongs_to :site, optional: true
  has_many :user_periodic_inspections, class_name: "JoinTable::UserPeriodicInspections"
  has_many :periodic_inspections, through: :user_periodic_inspections
  has_many :user_setups, class_name: "JoinTable::UserSetups"
  has_many :setups, through: :user_setups
  has_many :user_takedowns, class_name: "JoinTable::UserTakedowns"
  has_many :takedowns, through: :user_takedowns
  has_many :comments

  validates_presence_of :fullname
  validates :email, presence: true, uniqueness: true
  has_secure_password

  def has_permissions?(level)
    case level
    when "admin"
      self.role == "admin"
    when "lead"
      self.role == "lead" || self.role == "admin"
    end
  end
end
