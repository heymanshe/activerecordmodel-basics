# Active Model

## What is Active Model?

- Active Model is a Ruby library that provides model-like behavior to plain Ruby objects without requiring a database. It extracts useful functionalities from Active Record and allows developers to implement features like validations, callbacks, and custom attributes in non-database-backed models.

## Relationship with Active Record

**Active Record**: An ORM (Object Relational Mapper) that connects objects to relational database tables.

**Active Model**: A set of modules extracted from Active Record to provide model-like behavior without requiring a database.

## Key Features of Active Model

**Validations**: Enables checking constraints on object attributes.

**Callbacks**: Hooks to trigger actions at different points in an object's lifecycle.

**Translations**: Provides internationalization (i18n) support.

**Custom Attributes**: Allows defining dynamic attributes in plain Ruby objects.


# 1. API 

- `ActiveModel::API` enables a class to work with `Action Pack` and `Action View`, providing essential features:

  - Attribute Assignment

  - Conversion

  - Naming

  - Translation

  - Validations

```ruby
class EmailContact
  include ActiveModel::API

  attr_accessor :name, :email, :message
  validates :name, :email, :message, presence: true

  def deliver
    if valid?
      # Deliver email
    end
  end
end
```

## Features Demonstrated

```bash
email_contact = EmailContact.new(name: "David", email: "david@example.com", message: "Hello World")

email_contact.name # => "David" (Attribute Assignment)
email_contact.to_model == email_contact # => true (Conversion)
email_contact.model_name.name # => "EmailContact" (Naming)
EmailContact.human_attribute_name("name") # => "Name" (Translation)
email_contact.valid? # => true (Validations)

empty_contact = EmailContact.new
empty_contact.valid? # => false
```

## Usage in Action View

### Form Helpers

- Can be used with form_with:

```html
<%= form_with model: EmailContact.new do |form| %>
  <%= form.text_field :name %>
<% end %>
```

- Generated HTML:

```html
<form action="/email_contacts" method="post">
  <input type="text" name="email_contact[name]" id="email_contact_name">
</form>
```

## Rendering

- Objects can be rendered using:

```bash
<%= render @email_contact %>
```

# 2. Model

`ActiveModel::Model` includes `ActiveModel::API` to interact with Action Pack and Action View by default. It's the recommended approach to implement model-like Ruby classes. This will be extended in the future for more functionality.

```ruby
class Person
  include ActiveModel::Model

  attr_accessor :name, :age
end
```

Usage Example:

```ruby
person = Person.new(name: 'bob', age: '18')
person.name # => "bob"
person.age  # => "18"
```

# 3. Attributes

`ActiveModel::Attributes` allows you to define data types, set default values, and handle casting and serialization for plain Ruby objects. This is especially useful for form data and provides ActiveRecord-like conversions for things like dates and booleans.

```ruby
class Person
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :date_of_birth, :date
  attribute :active, :boolean, default: true
end
```

### Example Usage:

```ruby
person = Person.new

person.name = "Jane"
person.name # => "Jane"

# Casting the string to a date
person.date_of_birth = "2020-01-01"
person.date_of_birth # => Wed, 01 Jan 2020
person.date_of_birth.class # => Date

# Default value
person.active # => true

# Casting the integer to a boolean
person.active = 0
person.active # => false
```

## 3.1 Method: `attribute_names`
Returns an array of attribute names.

```ruby
Person.attribute_names
# => ["name", "date_of_birth", "active"]
```

## 3.2 Method: `attributes`
Returns a hash of all the attributes with their names as keys and the values of the attributes as values.

```ruby
person.attributes
# => {"name" => "Jane", "date_of_birth" => Wed, 01 Jan 2020, "active" => false}
```

# 4. Attribute Assignment

### `assign_attributes`
- Allows setting multiple object attributes by passing a hash where keys match attribute names.
- Example:

```ruby
class Person
  include ActiveModel::AttributeAssignment
  attr_accessor :name, :date_of_birth, :active
end
```

```
person = Person.new
person.assign_attributes(name: "John", date_of_birth: "1998-01-01", active: false)
puts person.name           # => "John"
puts person.date_of_birth  # => Thu, 01 Jan 1998
puts person.active         # => false
```

**Strong Params Integration**: If a hash responds to `permitted?` method and returns false, an `ActiveModel::ForbiddenAttributesError` is raised.

```bash
params = ActionController::Parameters.new(name: "John")
params.permit(:name)  # Allows safe assignment
person.assign_attributes(params)
```

## `attributes=`

- Alias for `assign_attributes` method.

- Both `assign_attributes` and `attributes=` accept a hash of attributes.

```bash
person.attributes = { name: "John", date_of_birth: "1998-01-01", active: false }
puts person.name           # => "John"
```

- Parentheses for methods with hashes can be omitted in Ruby for cleaner syntax, but syntax must be correct.
