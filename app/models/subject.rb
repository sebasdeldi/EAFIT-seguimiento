class Subject < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def self.search_subject(search)
    where("name ILIKE ? OR code ILIKE ? ", "%#{search}%", "%#{search}%")
  end

  def self.import(file)
    spreadsheet = Roo::Excelx.new(file)
    spreadsheet.each_with_pagename do |name, sheet|
      name = sheet.cell(2, "B").split("-")[1]
      semester = sheet.cell(1, "B").split(" ")[1]
      group = sheet.cell(3, "B").split(" ")[1]
      code = semester + sheet.cell(2, "B").split("-")[0].split(" ")[1] + "-" + group
      subject = Subject.create!(name: name, code: code)
      (9..sheet.last_row).each do |i|
        student = User.where(code: sheet.cell(i, 'B')).first
        unless student == nil
          subject.users << student unless subject.users.include?(student)
        end
      end
    end
  end
end
