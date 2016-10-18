require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject

  #returns an array of column names from the table that matches the object name
  def self.columns
    if @columns.nil?
      cols = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
      SQL
      @columns = cols.first.map(&:to_sym)
    end
    @columns
  end

  #defines attr_accessor methods for each column in the specified table
  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        attributes[col]
      end
      col_with_equal = (col.to_s + '=').to_sym
      define_method(col_with_equal) do |arg|
        attributes[col] = arg
      end
    end
  end

  #sets a table name if not already defined
  def self.table_name=(table_name)
    @table_name ||= table_name
  end

  #translates the model class name into a plural, lowercase SQL table name
  def self.table_name
    "#{self}".downcase + "s"
  end

  #fetches all instances of the model class from the database
  #returns array of model objects with attributes
  def self.all
    rows = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL
    self.parse_all(rows)
  end

  #creates a new model object from each result from the database
  def self.parse_all(results)
    objs = []
    results.each do |hash|
      objs << self.new(hash)
    end
    objs
  end

  #locates an entry in the database with the specified id
  #returns the first matching object
  def self.find(id)
    find = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL
    self.parse_all(find).first
  end

  #fetches the first instance of the model class
  def self.first
    self.all[0]
  end

  #fetches the last instance of the model class
  def self.last
    self.all[self.all.length - 1]
  end

  #creates a new instance of model class with attribute parameters passed in
  #raises error for invalid attributes
  def initialize(params = {})
    params.each do |k, v|
      key = k.to_sym
      raise "unknown attribute '#{k}'" unless self.class.columns.include?(key)
      key = (key.to_s + '=').to_sym
      #uses the key value to call a setter method for that attribute
      self.send(key, v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  #returns an array of values for each column the database for this instance of model class
  def attribute_values
    @attributes ||= {}
    self.class.columns.map { |col| self.send(col)}
  end

  #puts created instance of model class into the database and assigns an id
  def insert
    vals = self.class.columns.join(', ')
    q_marks = []
    attribute_values.length.times { q_marks << '?' }
    q_marks = q_marks.join(', ')
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{vals})
      VALUES
        (#{q_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  #updates an existing entry in the database
  def update
    set_str = self.class.columns.join(' = ?, ')
    set_str += ' = ?'
    DBConnection.execute(<<-SQL, *attribute_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_str}
      WHERE
        id = #{self.id}
    SQL
  end

  def save
    if self.id.nil?
      insert
    else
      update
    end
  end
end
