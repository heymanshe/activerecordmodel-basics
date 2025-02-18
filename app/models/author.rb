class Author
  include ActiveModel::AttributeAssignment

  attr_accessor :name, :date_of_birth, :active
end
