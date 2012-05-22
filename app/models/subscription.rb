class Subscription < ActiveRecord::Base
  attr_accessible :user, :subscriber, :subscriber_id, :user_id, :last_status_id

  belongs_to :user
  belongs_to :subscriber, :class_name => "User"

  validates_uniqueness_of :subscriber_id, :scope => :user_id
end

# == Schema Information
#
# Table name: subscriptions
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  subscriber_id  :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  last_status_id :integer
#

