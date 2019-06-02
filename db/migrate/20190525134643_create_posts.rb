class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :body, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :account, index: true, foreign_key: true, null: false
      t.integer :question_id, index: true, foreign_key: true, null: true
      t.integer :views_count, default: 0
      t.integer :answers_count, default: 0
      t.timestamps
    end

    add_index :posts, [:slug], :unique => true, :name => 'index_unique_slug'

  end
end
