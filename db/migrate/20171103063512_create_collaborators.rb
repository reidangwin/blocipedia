class CreateCollaborators < ActiveRecord::Migration[5.1]
  def change
    create_table :collaborators do |t|
      t.references :wiki, index: true
      t.references :user, index: true
      t.timestamps
    end

    add_index :collaborators, :id, unique: true
  end
end
