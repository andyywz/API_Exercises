class Hashtag

	attr_reader :tag

	def initialize(tag)
		@tag = tag
	end

	def self.parse_many(arr)
		out = []
		arr.each do |tag|
			out << Hashtag.new(tag["text"])
		end
		out
	end

end