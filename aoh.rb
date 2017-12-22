#	[Written By: Vivex - eigenfruit@gmail.com] #

require 'fileutils'
# last updated: 2017-12-13

#TODO:
=begin
	-2017-Dec-13
	* Implemented reverse_add(hash) -- appends to the front of @collection instead of adding to the back as usual.

	-24-Sep-14 : most of the day
	* Implemented File saving methods: [aoh_object].save!(file_location: "test", aoh: nil)
	* As a side note: you may have to modify the get_id instance method to return a certain string (or false)
	  if there is no id at that particular location. Also, will rem_id return an error if it can't
	  find any data at that location.

	-20-Sep-14 : 10:40am-
	* Create an Exception library (inheriting StandardError)
	* Find a way to implement containers, where every function below can perform operations based on what type or 
	  What's inside the container <-- .map :p
	
	-20-Sep-14 : 5:37pm-
	* Make self.load and self.save more secure by using something like Base64.encode / Base64.decode
	
	-03-Oct-14 : 7:57am-
	* See if there's a way to make it so that get_id(n) doesn't return an array with hashes inside
	  ...Albeit, this works fine if we're dealing with getting multiple id's at the ssame time

=end
	

class AOH #Array-of-hashes container
	def initialize(*args)

		@collection=[]
		@path_to_root=nil #we give a default path for some instance object of AOH, to make specifying where a file is to be saved with a bit more ease
		args.map{|a_hash| add(a_hash) }
		
	end

	def add(hash)
		
		 if hash.is_a? Hash #this is where you could check to see what kind of classN it is then react accordingly
		 	@collection.push(hash)
		 else
		 	raise "#{hash.inspect} is NOT a Hash..."
		 end
		
	end


	def reverse_add(hash)
		if hash.is_a? Hash
			@collection.unshift(hash)
		else
			raise "#{hash.inspect} is NOT a Hash..."
		end
	end


	def collection_get
		@collection
	end

	def first
		@collection[0]
	end

	def last
		@collection.last
	end

	def max		
		@collection.size-1
	end


	def clear_then_save

	end

	def get_id(id=nil) #or nil to get all ---- THIS IS WHERE you may have to make a modification on the return of @collection[id]

		if @collection.empty?
			return nil
		elsif id==nil
			return map {|i| i}
		else
			return nil if id < 0 or id > @collection.size
			return @collection[id.to_i]
		end

	end

	def set_id(id, &block)
		raise "Improper id: #{id}" if !id.is_a? Integer
		raise "No block given in set_id()" if !block_given?		 

		hash=get_id(id)
		if hash == nil #there is nothing here
			raise "#{id} not in #{hash.inspect}"
		else

			block.call( get_id(id) )

		end

	end

	

	def rem_by_id(id)
		raise "id is not an integer" if !id.is_a? Integer
		@collection.delete_at(id)
	end


	def each_with_index(&block)
		raise "block not given in each_with_index(&block)" if !block_given?
		#@collection.each_with_index.map {|a_hash, index| yield [a_hash, index]}	#now figure out a nice way to add to the arguments...
		@collection.each_with_index.map {|a_hash, index| yield [a_hash, index]}	#now figure out a nice way to add to the arguments...		
	end


	def map(&block)
		raise "block not given in map(&block)" if !block_given?
		#@collection.each_with_index.map {|a_hash, index| yield [a_hash, index]}	#now figure out a nice way to add to the arguments...
		@collection.map {|a_hash| block.call(a_hash) }	#now figure out a nice way to add to the arguments...		
	end

	def each
		@collection.map {|hash| hash}
	end

	def print_all
		loc=0
		each do |hash|
			hash.each_pair do |id, data|
				puts "Loc[#{loc}]: #{id.inspect} => #{data.inspect}" #you could put a yield here one of these days
			end
			loc += 1
			puts "\n\n"
		end
		
	end	

	def self.save(aoh: nil, file_location: "test") 
	
		File.open(file_location, 'w') do |file_handle|
			raise "AOH undefined" unless aoh.class == AOH
			Marshal.dump(aoh, file_handle)
		end

		aoh

	end

	def self.touch!(file_location: "test")
		
		if !file_location
			FileUtils.touch(file_location) 
			load!(file_location: file_location)
		end

	end

	def save!(file_location: "test", aoh: nil)				
		self.class.save(file_location: file_location, aoh: self)
	end


	def self.save!(aoh: AOH.new(), file_location: nil) #save no matter what		

		raise "file_location not specified or is nil (file_location: #{file_location.inspect})" if !file_location
	
		File.open( file_location , 'w' ) do |file_handle|

			Marshal.dump(aoh, file_handle)

		end
		
	end
	

	def self.load!(aoh: AOH.new(), file_location: nil, s_self: nil) #factory method; returns an AOH object with those specific array-of-hashes (will create a new file if file does not exist; use iff certain that you know what file you're loading)
		raise "file_location not specified or is nil (file_location: #{file_location})" if !file_location
		
		loaded=false
		if !File.exist? file_location
					
			touch!(file_location: file_location)
			save!(aoh: aoh, file_location: file_location)

		end


		File.open( file_location) do |file_handle|
			loaded=Marshal.load( file_handle )
	    end

		loaded

	end

	def self.load(file_location: "test") #factory method; returns an AOH object with those specific array-of-hashes
		loaded=false

		File.open( file_location ) do |file_handle|
			loaded=Marshal.load( file_handle )
		end

		loaded
	end


end


#p aoh_object=AOH.new({:tag1 => 3.141519567, :tag2 => AOH.new({:tag1 => 1, :tag => 2})})
#aoh_object.set_id(0) do |hash|

#	p hash[:blah] = "something"

#end

#p aoh_object.get_id(0)
