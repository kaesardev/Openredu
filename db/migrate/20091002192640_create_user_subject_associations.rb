class CreateUserSubjectAssociations < ActiveRecord::Migration
  def self.up
    create_table :user_subject_associations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :user_subject_associations
  end
end
