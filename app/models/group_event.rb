class GroupEvent < ActiveRecord::Base
  belongs_to :user

  EDITABLE_ATTRIBUTES = GroupEvent.attribute_names - %w(id created_at modified_at)
  validates_presence_of EDITABLE_ATTRIBUTES, if: :published?

  def disable!
    update(enabled: false)
  end

  def publish!
    update(published: true)
  end

  def self.enabled
    where(enabled: true)
  end
end
