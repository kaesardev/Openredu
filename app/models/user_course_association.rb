class UserCourseAssociation < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :course
  
  belongs_to :access_key
  has_enumerated :role
  
end
