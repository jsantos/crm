class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.references :company, null: false, foreign_key: true
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :age, null: false

      t.timestamps
    end

    # Many-to-many relation through has_and_belongs_to_many
    # https://guides.rubyonrails.org/association_basics.html#the-has-and-belongs-to-many-association
    create_table :groups_users, id: false do |t|
      t.belongs_to :group
      t.belongs_to :user
    end
  end
end
