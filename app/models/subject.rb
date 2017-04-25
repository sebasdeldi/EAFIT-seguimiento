class Subject < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def self.search_subject(search)
    where("name ILIKE ? OR code ILIKE ? ", "%#{search}%", "%#{search}%")
  end

  def self.import(file)
    spreadsheet = Roo::Excelx.new(file)
    name = spreadsheet.cell(2, "B").split("-")[1]
    semester = spreadsheet.cell(1, "B").split(" ")[1]
    group = spreadsheet.cell(3, "B").split(" ")[1]
    code = semester + spreadsheet.cell(2, "B").split("-")[0].split(" ")[1] + "-" + group
    subject = Subject.create!(name: name, code: code)
    (9..spreadsheet.last_row).each do |i|
      student = User.where(code: spreadsheet.cell(i, 'B')).first
      unless student == nil
        subject.users << student unless subject.users.include?(student)
      end
    end
  end
end
