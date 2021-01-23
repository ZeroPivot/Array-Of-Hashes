# Array-Of-Hashes
# Array Of Hashes algorithm in Ruby

Something I made to act as a simple database for my ComicMan project. TODO is making a documentation for it, but chances are there are
far better libraries out there anyways.

# Usage:

When starting out with no database, you can stil use `AOH.load!(...)`, or:
`DB = AOH.new()`

or

To create an instance of the database that runs in memory (with the hash data), of course. If no args are specified, an empty aoh database is created:
`DB = AOH.new(<hashes, separated by commas; optional>)`

or

`DB = AOH.new()`

Load an existing database file, or create one at that location (when you save):
`DB = AOH.load!(file_location: "/your/file/here.db") #Loads here.db, and will create a new database file if one doesn't exist`

Saves the database to specified location:
`AOH.save!(file_location: "/your/file/here.db")`
                                                        
Returns the hash data of the integer id array indice                                                                                       
`data_hash = DB.get_id(integer)`

Set an existing ID in DB with some data
```
DB.set_id(integer) do |config|
  data[:some_hash] = "some string"
  # ...
  data[:some_other_hash] = 42
 end
 
```
# Add to the database:
 
 Append to the end of the array all hash data speficied in args
```
 DB.add(data_hash1: "data", ..., data_hashN: "dataN", data_hashInt: 42)
 DB.reverse_add(...) #=> identical to above, but sets id to be the first in the array
```
 
 Save the database
 `DB.save!(file_location: "/your/file/here.db")`


And to remove an indice:
`DB.rem_by_id(integer_id)`
