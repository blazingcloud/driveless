class Community < ActiveRecord::Base
  has_many :users
  validates_presence_of :name, :state, :country

  before_destroy :ensure_there_are_no_members

  private

  def ensure_there_are_no_members
    raise "This community can't be deleted as there are #{users.count} users in it" if users.any?
  end
end
