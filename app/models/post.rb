class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 500 }
  mount_uploader :image, ImageUploader
  include PgSearch
  pg_search_scope :search_by_content, :against => [:title, :body], :using => { tsearch: { any_word: true, prefix: true } }
end
