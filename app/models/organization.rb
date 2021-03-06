class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :members, :dependent => :destroy
  has_many :users, :through => :members
  has_many :moderators, -> { where :members => { :role => 1 } }, :through => :members, :source => :user
  has_many :admins, -> { where :members => { :role => 2 } }, :through => :members, :source => :user
  has_many :campains, :dependent => :destroy
  has_many :statuses, :as => :statusable
  has_many :activities
  has_many :world_members
  has_many :teams

  accepts_nested_attributes_for :members, :users

  mount_uploader :avatar, OrganizationAvatarUploader
  mount_uploader :cover_image, OrganizationCoverImageUploader

  # User joins organization
  def join(user)
    members.create(:user => user, :role => 0)
  end

  # User exit organization
  def exit(user)
    members.find_by(:user => user).destroy
  end

  # is following
  def member?(user)
    members.include?(user)
  end

  def available_campains?
    owner = admins.where(:id => self.owner_id).first
    owner.campains_quota_full?
  end

  def available_events?
    owner = admins.where(:id => self.owner_id).first
    owner.events_quota_full?
  end

  def subscription_plan
    owner = admins.where(:id => self.owner_id).first
    owner.active_subscription
  end

  def owner
    admins.where(:id => self.owner_id).first
  end

  def number_of_campains
    owner.number_of_campains_user_ownes
  end

  def number_of_events
    owner.number_of_events_user_ownes
  end

  def self.user_search(organization_id, keywords, role)
    search = User.joins(:members).where("members.organization_id = ?", organization_id)
    search = search.where("lower(first_name) LIKE ? OR lower(last_name) LIKE ?", "%#{keywords.downcase}%", "%#{keywords.downcase}%") if keywords.present?
    search = search.where("members.role = ?", role.to_i) if role.present?
    search
  end
end
