require 'mongoid'

DB_CONFIG = 'mongoid.config'

Mongoid.load! DB_CONFIG

class User
  include Mongoid::Document

  before_validation :generate_token

  field :name, type: String
  field :token, type: String

  validates :name, presence: true
  validates :token, presence: true

  index(name: 'text')
  index({ token: 1 }, { unique: true, name: 'token_index' })

  private

  def generate_token
    self.token = Digest::SHA256.hexdigest(Time.now.to_s)
  end
end
