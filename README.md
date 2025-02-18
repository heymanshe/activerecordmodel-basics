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


# 5. Attribute Methods

`ActiveModel::AttributeMethods`

- Allows dynamic method generation for attributes, like creating methods with prefixes, suffixes, or both.

```ruby
class Person
  include ActiveModel::AttributeMethods

  attribute_method_affix prefix: "reset_", suffix: "_to_default!"
  attribute_method_prefix "first_", "last_"
  attribute_method_suffix "_short?"
  
  define_attribute_methods "name"
  attr_accessor :name

  private
  def first_attribute(attribute)
    public_send(attribute).split.first
  end
  
  def last_attribute(attribute)
    public_send(attribute).split.last
  end

  def attribute_short?(attribute)
    public_send(attribute).length < 5
  end

  def reset_attribute_to_default!(attribute)
    public_send("#{attribute}=", "Default Name")
  end
end
```

```bash
person = Person.new
person.name = "Jane Doe"

puts person.first_name         # => "Jane"
puts person.last_name          # => "Doe"
puts person.name_short?        # => false
puts person.reset_name_to_default!  # => "Default Name"
```

- Methods for attributes are dynamically created based on method names defined with prefixes or suffixes.

- `public_send` is used to dynamically access attribute values.

## `alias_attribute`

- Used to create alias methods for attributes.

- Both the original and alias return the same value.

```ruby
class Person
  include ActiveModel::AttributeMethods
  attr_accessor :name
  
  alias_attribute :full_name, :name
end
```

```bash
person = Person.new
person.name = "Joe Doe"
puts person.full_name  # => "Joe Doe"
```

- Alias methods can be created for any existing attributes, providing a more semantic or descriptive name.

## Method Naming Restrictions

- Ensure method names for dynamically generated methods follow the syntax correctly to avoid `NoMethodError`.

# 6. ActiveModel::Callbacks

`ActiveModel::Callbacks` gives plain Ruby objects Active Record-style callbacks. It allows you to hook into model lifecycle events like `before_update`, `after_create`, etc., and define custom logic at specific lifecycle points.

## Steps to Implement Callbacks

1. **Extend `ActiveModel::Callbacks`** within your class.
2. **Define Callbacks** with `define_model_callbacks` for specific lifecycle events. For example, using `:update` automatically includes `before`, `around`, and `after` callbacks.
3. **Use `run_callbacks`** to trigger the callback chain when the event is called.

```ruby
class Person
  extend ActiveModel::Callbacks

  define_model_callbacks :update

  before_update :reset_me
  after_update :finalize_me
  around_update :log_me

  def update
    run_callbacks(:update) do
      puts "update method called"
    end
  end

  private
    def reset_me
      puts "reset_me method: called before the update method"
    end

    def finalize_me
      puts "finalize_me method: called after the update method"
    end

    def log_me
      puts "log_me method: called around the update method"
      yield
      puts "log_me method: block successfully called"
    end
end
```

### Callback Execution Order

- When calling person.update, the following sequence will happen:

```bash
reset_me method: called before the update method
log_me method: called around the update method
update method called
log_me method: block successfully called
finalize_me method: called after the update method
```

- `before_*`: Runs before the specified action.
- `after_*`: Runs after the specified action.
- `around_*`: Runs before and after the specified action. Make sure to yield within the block to allow the action to proceed.

### Defining Specific Callbacks

- You can define specific callbacks by using the only option in define_model_callbacks:

```bash
define_model_callbacks :update, :create, only: [:after, :before]
```

- This will only create `before_*` and `after_*` callbacks and skip `around_*`.

- It’s possible to call define_model_callbacks multiple times for different lifecycle events:

```ruby
define_model_callbacks :create, only: :after
define_model_callbacks :update, only: :before
define_model_callbacks :destroy, only: :around
```

### Defining Callbacks with a Class

- You can pass a class to the callback methods for more control. The class should define the <action>_<type> method:

```ruby
class Person
  extend ActiveModel::Callbacks

  define_model_callbacks :create
  before_create PersonCallbacks
end

class PersonCallbacks
  def self.before_create(obj)
    # obj is the Person instance
  end
end
```

### Aborting Callbacks

- Callbacks can be aborted by throwing `:abort`, preventing the remainder of the callback chain from executing:

```ruby
class Person
  extend ActiveModel::Callbacks

  define_model_callbacks :update

  before_update :reset_me
  after_update :finalize_me
  around_update :log_me

  def update
    run_callbacks(:update) do
      puts "update method called"
    end
  end

  private
    def reset_me
      puts "reset_me method: called before the update method"
      throw :abort  # This will stop the callback chain
    end

    def finalize_me
      puts "finalize_me method: called after the update method"
    end

    def log_me
      puts "log_me method: called around the update method"
      yield
      puts "log_me method: block successfully called"
    end
end
```

- If `:abort` is thrown before executing the main action, the callback chain stops and the action won’t run:

```bash
reset_me method: called before the update method
=> false
```

### Key Points

- `method_name` passed to `define_model_callbacks` should not end with `!`, `?`, or `=`.

- Defining the same callback multiple times will overwrite previous definitions.

- Use `yield` in `around_*` callbacks to ensure the action is executed.

