# Active Data

Active Data provides a way for Ruby objects to connect with relational database
tables and allows for associations between different class models.

Objects created using Active Data will inherit from a `SQLObject` class and use
strict naming conventions to directly tie that class model to a table of the
same name. For example, a `Cat` object will relate to a table named `cats`.

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
