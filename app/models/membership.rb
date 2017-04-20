class Membership < ApplicationRecord
  belongs_to :subject
  belongs_to :user
end
