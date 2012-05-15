class Tweet < Growl
  LINK_GSUB = /(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix
  def comment_with_link
    gsub_links
    gsub_username
    self.comment
  end

  def gsub_links
    links = self.comment.scan(LINK_GSUB)
    links.each do |link|
      real_link = "<a href='#{link}'>#{link}</a>"
      self.comment = comment.gsub("#{link}", real_link)
    end
  end

  def gsub_username
    usernames = self.comment.scan(/@(\w+)\s/)
    usernames.each do |username|
      link = "<a href='http://twitter.com/#{username.first}'>@#{username.first}</a>"
      self.comment = comment.gsub("@#{username.first}", link)
    end
  end

  def icon
    "glyphicons_392_twitter.png"
  end
end
# == Schema Information
#
# Table name: growls
#
#  id                 :integer         not null, primary key
#  type               :string(255)
#  comment            :text
#  link               :text
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  user_id            :integer
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  external_id        :integer
#
