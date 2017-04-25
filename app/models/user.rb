class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   validates :names, presence: true
   validates :last_names, presence: true
   validates :highschool, presence: true
   validates :origin_municipality, presence: true
   validates :address, presence: true
   validates :living_municipality, presence: true
   validates :living_neighbourhood, presence: true
   validates :scolarship, presence: true
   validates :role, presence: true
   validates :computer_access, presence: true
   validates :technical_education, presence: true

  has_many :memberships
  has_many :subjects, through: :memberships

  def self.import(file)
    spreadsheet = Roo::Excelx.new(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      User.create!(row)
    end
  end

  def self.search_students(search)
    where("names ILIKE ? OR last_names ILIKE ?", "%#{search}%", "%#{search}%").where("role = ?", "student" )
  end

  def self.search_teachers(search)
    where("names ILIKE ? OR last_names ILIKE ? ", "%#{search}%", "%#{search}%").where("role = ?", "teacher" )
  end

end
