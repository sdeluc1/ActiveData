require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.to_s.constantize
  end

  def table_name
    self.class_name.downcase + 's'
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = (name.to_s + '_id').to_sym if options[:foreign_key].nil?
    @class_name = name.to_s.capitalize if options[:class_name].nil?
    @primary_key = :id if options[:primary_key].nil?

    @foreign_key ||= options[:foreign_key]
    @class_name ||= options[:class_name]
    @primary_key ||= options[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})

    @foreign_key = (self_class_name.downcase + '_id').to_sym if options[:foreign_key].nil?
    @class_name = name[0...-1].capitalize if options[:class_name].nil?
    @primary_key = :id if options[:primary_key].nil?

    @foreign_key ||= options[:foreign_key]
    @class_name ||= options[:class_name]
    @primary_key ||= options[:primary_key]
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      f_key = send(options.foreign_key)
      options.model_class.where(id: f_key).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      f_key = send(options.primary_key)
      p_key = options.foreign_key
      options.model_class.where(p_key => f_key)
    end
  end

end

class SQLObject
  extend Associatable
end
