class Subject < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def self.search_subject(search)
    where("name ILIKE ? OR code ILIKE ? ", "%#{search}%", "%#{search}%")
  end
end
