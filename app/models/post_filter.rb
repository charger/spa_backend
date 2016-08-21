class PostFilter
  include ActiveModel::Model
  PER_PAGE = 5

  attr_accessor :filter, :order, :order_direction, :page

  def posts
    res = Post.all
    res = res.search_by_content(filter) if filter
    if order
      direction = order_direction || 'asc'
      direction = 'asc' unless %w(asc desc).include?(direction)
      res = res.order(order => direction)
    end
    res.page(page).per(PER_PAGE)
  end
end
