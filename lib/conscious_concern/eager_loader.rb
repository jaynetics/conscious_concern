module ConsciousConcern
  #
  # Recursively finds Ruby Classes in a given directory.
  #
  class EagerLoader
    DEBUG = false

    def self.load_classes_in_rails_dir(name)
      rails = Object.const_defined?('Rails') ? 'Rails'.constantize : nil
      unless rails && rails.root
        puts 'no initialized Rails application' if DEBUG
        return false
      end
      load_classes_in(rails.root.join('app', name))
    end

    def self.load_classes_in(dir)
      Dir.foreach(dir) do |entry|
        if entry.end_with?('.rb')
          class_from_filename(entry)
        elsif File.directory?(dir.join(entry)) && entry[0] != '.'
          load_classes_in(dir.join(entry))
        end
      end
    end

    def self.class_from_filename(filename)
      clazz = filename[0..-4].classify.constantize
      puts "eager loaded class '#{clazz}'" if DEBUG
    rescue => e
      puts e.message if DEBUG
    end
  end
end
