class User
  include ActiveModel::Model

  attr_accessor :name, :email

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
