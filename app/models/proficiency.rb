class Proficiency < ActiveRecord::Base

  validates :years_experience, :presence => true
  validates :formal_training, :inclusion => { :in => [true,false] }
  belongs_to :skill
  belongs_to :user
  # Remember to create a migration!
end
