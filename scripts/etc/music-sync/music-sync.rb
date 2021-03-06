# encoding : utf-8
# Will synchronize all directories marked for the specified target onto that
# target.
# Usage :
#  $ music-sync /path/to/music/library sansa
require_relative "syncinfo"
require "fileutils"
require "shellwords"

class MusicSync
	class Error < StandardError; end
	class ArgumentError < Error; end
	class UndefinedTarget < Error; end
	class NoMusicRoot < Error; end

	def initialize(*args)
		# Check for dry run
		if args.include?('-n')
			args.delete('-n')
			@dry_run = true
		end

		if args.size != 3
      puts "Usage :"
      puts "$ music-sync /library/path /device/path device_name"
      exit
		end

		# Check that library directory exists
		@library_path = File.expand_path(args[0])
		unless File.exists?(@library_path) && File.directory?(@library_path)
			raise MusicSync::ArgumentError, "Library path #{@library_path} is invalid", ""
		end
    @target_path = File.expand_path(args[1])
		unless File.exists?(@target_path) && File.directory?(@target_path)
			raise MusicSync::ArgumentError, "Target path #{@target_path} is invalid", ""
		end
		@target_name = args[2]
	end

	# Get all syncinfo files in the library
	def get_syncinfo_list
		Dir[File.join(@library_path, '**', '.syncinfo')].map{|file| File.dirname(file)}
	end

	# Get all directories marked for a specified target
	def get_marked_directories
		filtered_list = []
		# Keeping only directories that have a syncinfo matching the target
		get_syncinfo_list.each do |path|
			syncinfo = Syncinfo.new(path)
			next unless syncinfo.has_target?(@target_name)
			filtered_list << path
		end
		return filtered_list
	end

	# Get all music marked directories
	def get_music_marked_directories
		get_marked_directories.reject do |dir|
			dir['/podcasts/']
		end
	end

	# Get all podcasts marked directories
	def get_podcast_marked_directories
		get_marked_directories.select do |dir|
			dir['/podcasts/']
		end
	end

	# Get the list of directories that will be synched
	def dry_run
		puts "Dry run : "
		get_marked_directories.each do |path|
			puts path
		end
	end

	# Get the library rootpath by looking for the .musicroot file
	def get_library_root
		split = @library_path.split("/")
		while last = split.pop
			path = File.join(*split, last, '.musicroot')
			return File.dirname(path) if File.exists?(path)
		end
		raise MusicSync::NoMusicRoot, "Unable to find music root for #{@library_path}", ""
	end

	# Synchronize files with the sansa SD card
	def synchronize_sansa_sd
		get_music_marked_directories.each do |dir|
			synchronize_dir(dir, File.join(@target_path, dir.gsub(/^#{get_library_root}/, '')))
		end
	end

	# Synchronize files with the sansa internal memory
	def synchronize_sansa
		get_music_marked_directories.each do |dir|
      puts dir
			synchronize_dir(dir, File.join(@target_path, dir.gsub(/^#{get_library_root}/, '')))
		end
		get_podcast_marked_directories.each do |dir|
			synchronize_podcast_dir(dir, File.join(@target_path, dir.gsub(/^#{get_library_root}/, '')))
		end
	end

	# Synchronize two dirs, copying files from source to destination
	def synchronize_dir(source, destination)
		# Create target directory if non-existent
		FileUtils.mkdir_p(destination)

		# Copying only mp3 files to destination
		options = [
			'--verbose', 
			'--archive',
			'--recursive',
			'--times',
			'--modify-window=1',
			'--prune-empty-dirs',
			"--filter='+s */'",
			"--filter='+s *.mp3'",
			"--filter='-s *'",
		]
		source+="/" if source[-1]!="/"

		puts "Synchronizing #{destination.split('/')[-3..-1].join('/')}"
		# puts "%x[rsync #{options.join(" ")} #{source.shellescape} #{destination.shellescape}]"
		%x[rsync #{options.join(" ")} #{source.shellescape} #{destination.shellescape}]
	end

	def synchronize_podcast_dir(source, destination)
		# Create target directory if non-existent
		FileUtils.mkdir_p(destination)

		# Lowest podcast in destination
		destination_files = Dir[File.join(destination, '*.mp3')]
		if destination_files.size > 0
			lowest_destination = File.basename(destination_files.sort.first)
			lowest_destination_id = lowest_destination.split(" - ")[0].to_i
		else
			lowest_destination_id = 0
		end

		# We only copy to destination podcasts in source that have an id equal or
		# higher
		Dir[File.join(source, '*.mp3')].sort.each do |file|
			basename = File.basename(file)
			next unless basename.split(" - ")[0].to_i >= lowest_destination_id
			options = [
				'--verbose', 
				'--archive',
				'--modify-window=1',
			]

			puts "Synchronizing #{basename}"
			# puts "%x[rsync #{options.join(" ")} #{file.shellescape} #{destination.shellescape}]"
			%x[rsync #{options.join(" ")} #{file.shellescape} #{destination.shellescape}]
		end
	end

	# Sync all music from the library to the target
	def run
		return dry_run if @dry_run
		puts "Synchronizing directories :"
		method_name = "synchronize_#{@target_name.gsub('-','_')}"
		self.send(method_name)
	end
end



