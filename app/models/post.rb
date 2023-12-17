class Post < ApplicationRecord
  belongs_to :account
  has_many :comments

  has_one_attached :image

  validate :validate_image_size
  validate :validate_image_type

  after_commit :set_image_url, on: [:create, :update]

  private

  def validate_image_size
    return unless image.attached? && image.blob.byte_size > 100.megabytes

    image.purge
    errors.add(:image, 'is too large (maximum is 100MB)')
  end

  def validate_image_type
    acceptable_types = %w[image/png image/jpg image/jpeg image/bmp]
    return unless image.attached? && !acceptable_types.include?(image.blob.content_type)

    image.purge
    errors.add(:image, 'must be a PNG, JPG, JPEG, or BMP')
  end

  def set_image_url
    return unless image.attached?

    url = Rails.application.routes.url_helpers.url_for(image)
    update_column(:image_url, url)
  end
end
