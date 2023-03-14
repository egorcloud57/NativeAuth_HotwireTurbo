class AddUserToNote < ActiveRecord::Migration[7.0]
  def change
    add_reference :notes, :user,index: true, null: false, foreign_key: true
  end
end
