class Micropost < ApplicationRecord
  MICROPOST_ATTRIBUTES = %i(content).freeze
  belongs_to :user
  scope :newest, ->{order created_at: :desc}
  validates :content, presence: true,
            length: {maximum: Settings.max_content_length}

  validates :image,
            content_type: {
              in: Settings.image_types,
              message: I18n.t("micropost.image_format")
            },
            size: {
              less_than: Settings.max_image_size.megabytes,
              message: I18n.t("micropost.image_size")
            }
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.micropost_image_width,
                        Settings.micropost_image_height]
  end
end
