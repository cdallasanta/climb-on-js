class JoinTable::UserSetups < ApplicationRecord
  self.table_name = "user_setups"
  belongs_to :user
  belongs_to :setup
end
