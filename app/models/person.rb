# class Person
#   include ActiveModel::Model

#   attr_accessor :name, :age
# end

# class Person
#   include ActiveModel::AttributeMethods

#   attribute_method_affix prefix: "reset_", suffix: "_to_default!"
#   attribute_method_prefix "first_", "last_"
#   attribute_method_suffix "_short?"

#   define_attribute_methods "name"

#   attr_accessor :name

#   private
#     def first_attribute(attribute)
#       public_send(attribute).split.first
#     end

#     def last_attribute(attribute)
#       public_send(attribute).split.last
#     end

#     def attribute_short?(attribute)
#       public_send(attribute).length < 5
#     end

#     def reset_attribute_to_default!(attribute)
#       public_send("#{attribute}=", "Default Name")
#     end
# end


class Person
  include ActiveModel::AttributeMethods

  attribute_method_suffix "_short?"
  define_attribute_methods :name

  attr_accessor :name

  alias_attribute :full_name, :name

  private
    def attribute_short?(attribute)
      public_send(attribute).length < 5
    end
end
