# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :text(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#  public_id  :string(255)
#

class Note < ActiveRecord::Base
  attr_accessible :content, :name
  belongs_to :user
  
  before_save :create_public_id

  validates :user_id, presence: true
  validates :name, presence: true

  default_scope order: 'notes.created_at DESC'

  private

    def create_public_id
      begin
        self.public_id = SecureRandom.urlsafe_base64(8)
      end while self.class.exists?(public_id: public_id)
    end
end
