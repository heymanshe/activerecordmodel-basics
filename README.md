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

