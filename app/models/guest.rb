class Guest < ActiveRecord::Base
  has_and_belongs_to_many :group
  belongs_to :party
end
