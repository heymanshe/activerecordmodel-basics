class Book
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :author, :string
  attribute :availability, :boolean, default: true
end
