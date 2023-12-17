class Post < ApplicationRecord
  belongs_to :account
  has_many :comments

  has_one_attached :image

  validate :validate_image_size
  validate :validate_image_type

  after_commit :enqueue_image_conversion

  private

  def validate_image_size
    if image.attached? && image.blob.byte_size > 100.megabytes
      errors.add(:image, 'is too large (maximum is 100MB)')
    end
  end

  def validate_image_type
    acceptable_types = %w[image/png image/jpg image/jpeg image/bmp]
    if image.attached? && !acceptable_types.include?(image.blob.content_type)
      errors.add(:image, 'must be a PNG, JPG, JPEG, or BMP')
    end
  end

  def enqueue_image_conversion
    return unless image.attached? && errors[:image].none? && image_url.nil?

    ImageConverterJob.perform_async(self.id)
  end
end
