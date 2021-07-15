class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :familyName
      t.string :givenName
      t.string :googleId
      t.string :imageUrl
      t.string :name
      t.string :password_digest 

      t.timestamps
    end
  end
end