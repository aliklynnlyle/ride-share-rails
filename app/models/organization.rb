class Organization < ApplicationRecord
  has_many :drivers, dependent: :destroy
  has_many :riders, dependent: :destroy
  has_many :rides, dependent: :destroy
  has_many :tokens, through: :riders

  validates :name, :street, :city, :state, :zip, presence: true
  validates :use_tokens, inclusion: { in: [ true, false ] }

end
