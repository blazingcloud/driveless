class Friendship < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  validates_presence_of   :user_id, :friend_id
  validates_uniqueness_of :user_id, :scope => :friend_id

  named_scope :of, lambda { |user| { :conditions => ['friendships.friend_id IN (?)', user.id]} }

end
