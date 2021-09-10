class CreateTodos < ActiveRecord::Migration[6.1]
  def change
    create_table :todos, id: :uuid do |t|
      t.string :title
      t.text :desc
      t.string :status
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
