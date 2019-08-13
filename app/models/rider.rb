class Rider < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :organization
  has_many :tokens
  has_many :rides

  validates :first_name, :last_name, :phone, :organization, presence: true
  # validates :email, presence: true


  def full_name
    first_name + " " + last_name
  end

  def valid_tokens
    self.tokens.where(is_valid: true).
                where('expires_at >= ?', Time.zone.now).
                where(ride_id: nil).
                order(:expires_at)
  end

  def next_valid_token
      self.valid_tokens.first
  end

  def valid_tokens_count
    self.valid_tokens.size
  end

end
