class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order created_at: :desc}
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.content_max_length}
  validates :image, content_type: { in: Settings.image_type,
    message: I18n.t("static_pages.account.mess_2") },
      size: { less_than: 5.megabytes,
        message: I18n.t("static_pages.account.mess_3") }

  scope :recent_posts, -> {order created_at: :desc}
  scope :feed_user, -> (following_ids, id){where "user_id IN (?) OR user_id = ?",
    following_ids, id}

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
