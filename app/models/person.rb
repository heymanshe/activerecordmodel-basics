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


# class Person
#   include ActiveModel::AttributeMethods

#   attribute_method_suffix "_short?"
#   define_attribute_methods :name

#   attr_accessor :name

#   alias_attribute :full_name, :name

#   private
#     def attribute_short?(attribute)
#       public_send(attribute).length < 5
#     end
# end


# class Person
#   extend ActiveModel::Callbacks

#   define_model_callbacks :update

#   before_update :reset_me
#   after_update :finalize_me
#   around_update :log_me

#   def update
#     run_callbacks(:update) do
#       puts "update method called"
#     end
#   end

#   private
#     def reset_me
#       puts "reset_me method: called before the update method"
#       # throw :abort
#     end

#     def finalize_me
#       puts "finalize_me method: called after the update method"
#     end

#     def log_me
#       puts "log_me method: called around the update method"
#       yield
#       puts "log_me method: block successfully called"
#     end
# end

class Person
  extend ActiveModel::Callbacks

  define_model_callbacks :create, only: [ :after, :before ]
  define_model_callbacks :update, only: :before
  define_model_callbacks :destroy, only: :around

  before_create :set_defaults
  before_update :validate_update
  around_destroy :log_destruction

  def create
    run_callbacks(:create) do
      puts "create method called"
    end
  end

  def update
    run_callbacks(:update) do
      puts "update method called"
    end
  end

  def destroy
    run_callbacks(:destroy) do
      puts "destroy method called"
    end
  end

  private
    def set_defaults
      puts "set_defaults: before create"
    end

    def validate_update
      puts "validate_update: before update"
    end

    def log_destruction
      puts "log_destruction: around destroy"
      yield
      puts "log_destruction: after destroy"
    end
end
