
class Hash
  def rename( old, new )
    self[ new ] = self.delete( old )
  end
end

class Class 
	# http://dev.rubyonrails.org/svn/rails/trunk/activesupport/lib/active_support/core_ext/class/attribute_accessors.rb
	# Extends the class object with class and instance accessors for class attributes,
	# just like the native attr* accessors for instance attributes.
	def cattr_reader(*syms)
	syms.flatten.each do |sym|
	  next if sym.is_a?(Hash)
	  class_eval(<<-EOS, __FILE__, __LINE__)
		unless defined? @@#{sym}
		  @@#{sym} = nil
		end

		def self.#{sym}
		  @@#{sym}
		end

		def #{sym}
		  @@#{sym}
		end
	  EOS
	end
	end

	def cattr_writer(*syms)
	options = syms.extract_options!
	syms.flatten.each do |sym|
	  class_eval(<<-EOS, __FILE__, __LINE__)
		unless defined? @@#{sym}
		  @@#{sym} = nil
		end

		def self.#{sym}=(obj)
		  @@#{sym} = obj
		end

		#{"
		def #{sym}=(obj)
		  @@#{sym} = obj
		end
		" unless options[:instance_writer] == false }
	  EOS
	end
	end

	def cattr_accessor(*syms)
		cattr_reader(*syms)
		cattr_writer(*syms)
	end
end

class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end


