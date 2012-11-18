# encoding : utf-8
# Display the list of current branches, colored according to git flow.


class GitBranchList
		@branch_colors = {
			:develop => 184,
			:master => 69,
			:hotfix => 160,
			:release => 28,
			:feature => 202,
			:bugfix => 203
		}

	def initialize(*args)
		@input = args[0] || `git branch --verbose`
	end

	# Parse a branch line into 4 useful parts
	def self.parse_line(line)
		regexp = /^(\*|\s?) (\S+)\s*(\w+) (.*)/
		match = regexp.match(line)
		return [ match[1] == "*", match[2], match[3], match[4] ]
	end

	def self.color_branchname(line)
		branches=/master|hotfix|release|develop|feature/
		suffix=/\/?[\w\/\-\.]*/

		line.gsub!(/((#{branches})#{suffix})/) do |foo|
			fullname, type = $1, $2
			type="bugfix" if fullname =~ /^feature\/bugfix/
			color=@branch_colors[type.to_sym]
			self.color_text(fullname, color)
		end
		return line


	end

	# Wrap a text in color codes
	def self.color_text(text, color)
		color = "%03d" % color
		return "[38;5;#{color}m#{text}[00m"
	end


end

