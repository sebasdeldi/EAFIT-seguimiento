module ApplicationHelper
  def current_subject(subject)
    if subject.name.include?('PRINCIPIOS')
      'principios'
    elsif subject.name.include?('FUNDAMENTOS')
      'fundamentos'
    elsif subject.name.include?('SEMINARIO')
      'seminario'
    end
  end
end
