require 'mini_magick'

class ImageConverterJob
  include Sidekiq::Job

  def perform(post_id)
    post = Post.find(post_id)
    return unless post.image.attached?

    # Process the image and convert it to JPG
    processed_image = process_image(post.image)

    # Create a new blob from the processed image
    new_blob = create_new_blob(processed_image, post)

    # Attach the new blob to the post
    post.image.attach(new_blob)

    post.update(image_url: Rails.application.routes.url_helpers.url_for(post.image))
  end

  private

  def process_image(image_attachment)
    image = MiniMagick::Image.new(ActiveStorage::Blob.service.send(:path_for, image_attachment.key))
    image.format "jpg"

    image.path
  end

  def create_new_blob(image_path, post)
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(image_path, 'rb'),
      filename: "post_#{post.id}.jpg",
      content_type: 'image/jpeg'
    )
  end
end
