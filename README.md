# Active Data

Active Data provides a way for Ruby objects to connect with relational database
tables and allows for associations between different class models.

Objects created using Active Data will inherit from a `SQLObject` class and use
strict naming conventions to directly tie that class model to a table of the
same name. For example, a `Cat` object will relate to a table named `cats`.

DEMO: navigate to `/lib` folder and run `ruby explorer.rb`

### Associations
  * Two models can relate by a `has_many` or `belongs_to` association:
  ```ruby
  class Guitar < SQLObject
    belongs_to :musician
  end

  class Musician < SQLObject
    has_many :guitars
    belongs_to :band
  end

  class Band < SQLObject
    has_many :musicians
  end
  ```

  * Running `Musician.first.guitars` will take the first `Musician` from the `musicians`
    table and return a list of `Guitar` objects that are owned by that `Musician`.

### `SQLObject` methods

#### Class Methods
  * `::all` - Returns a list of every row in a particular table
  * `::columns` - Returns a list of each column name in a particular table
  * `::finalize!` - Creates setter and getter methods for each table column:
  ```ruby
    Band.finalize!
    Band.columns # => [:id, :name]
    b = Band.new
    b.name = "Radiohead"
    b.name #=> "Radiohead"
  ```
  * `::find(id)` - Fetches a row with a matching `id` and returns a new object
  * `::first`, `::last` - Returns the first or last row in a table as a new object
