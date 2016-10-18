require_relative 'db_connection'
require_relative 'sql_object'
require 'byebug'

module Searchable
  def where(params)

    where_line = params.keys.map { |key| "#{key} = ? "}.join(' AND ')
    search = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    self.parse_all(search)
  end
end

class SQLObject
  extend Searchable
end
