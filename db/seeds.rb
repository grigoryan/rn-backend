# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
ActiveRecord::Base.transaction do
  # Clear data
  Comment.delete_all
  Post.delete_all
  Account.delete_all

  # Reset primary key sequences
  ActiveRecord::Base.connection.reset_pk_sequence!('comments')
  ActiveRecord::Base.connection.reset_pk_sequence!('posts')
  ActiveRecord::Base.connection.reset_pk_sequence!('accounts')

  image_path = Rails.root.join('db', 'space.jpg')

  10.times do
    Account.create!(
      name: Faker::Name.name  # Using the Faker gem to generate names
    )
  end

  Account.all.each do |account|
    rand(0-20).times do
      post = account.posts.create!(
        caption: Faker::Lorem.sentence,
      )

      if File.exists?(image_path)
        post.image.attach(io: File.open(image_path), filename: 'space.jpg', content_type: 'image/jpeg')
      end

      rand(0..15).times do
        post.comments.create!(
          content: Faker::Lorem.sentence,
          account_id: Account.order('RANDOM()').first.id  # Random account as the author of the comment
        )
      end
    end
  end
end

