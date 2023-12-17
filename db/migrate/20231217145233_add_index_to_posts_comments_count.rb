class AddIndexToPostsCommentsCount < ActiveRecord::Migration[7.0]
  def change
    add_index :posts, :comments_count
  end
end
