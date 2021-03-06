# == Schema Information
#
# Table name: shelf_books
#
#  id         :integer          not null, primary key
#  shelf_id   :integer
#  book_id    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShelfBook < ActiveRecord::Base
  attr_accessible :book_id

  belongs_to :shelf

  validates :shelf_id, presence: true
  validates :book_id, presence: true
end
