class PostsController < ApplicationController
  def index
    posts = Post.all
    render json: posts, include: :comments
  end

  def index_with_last_two_comments
    page = params[:page] || 1
    per_page = 10
    # Limiting the number of posts to 10 to avoid performance issues
    # per_page = params[:per_page] || 10
    offset = (page.to_i - 1) * per_page.to_i

    # Assuming that there is no comment edit/delete functionality.
    # Otherwise we need to order by comments.created_at and add index to comments.created_at
    sql = <<-SQL
    WITH RankedComments AS (
      SELECT
          comments.*,
          accounts.name as author_name,
          ROW_NUMBER() OVER (PARTITION BY post_id ORDER BY comments.id DESC) as rank
      FROM comments
      JOIN accounts ON comments.account_id = accounts.id
    )
    SELECT
      posts.id,
      posts.caption,
      posts.image_url,
      post_authors.name as post_author_name,
      post_authors.id as post_author_id,
      json_agg(
          json_build_object('id', rc.id, 'content', rc.content, 'author_id', rc.account_id, 'author_name', rc.author_name)
          ORDER BY rc.rank
      ) FILTER (WHERE rc.rank <= 2) as latest_comments
    FROM
      posts
    JOIN
      accounts post_authors ON posts.account_id = post_authors.id
    LEFT JOIN
      RankedComments rc ON posts.id = rc.post_id
    GROUP BY
      posts.id, post_author_id, post_author_name
    ORDER BY
      posts.comments_count DESC
    LIMIT #{per_page}
    OFFSET #{offset};
    SQL

    raw_posts_with_comments = ActiveRecord::Base.connection.execute(sql)
    posts_with_comments = raw_posts_with_comments.map do |record|
      post = {
        id: record['id'],
        caption: record['caption'],
        author: record['post_author_name'],
        image: record['image_url'],
        comments: JSON.parse(record['latest_comments'] || '[]')
      }
    end
    render json: posts_with_comments
  end

  def show
    post = Post.find(params[:id])
    render json: post, include: :comments
  end

  def create
    post = Post.new(post_params)
    post.account_id = post_params[:account_id]

    if post.save
      render json: post, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:caption, :image, :account_id)
  end
end
