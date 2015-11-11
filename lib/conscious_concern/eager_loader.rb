module ConsciousConcern
  #
  # Recursively finds Ruby Classes in a given directory.
  #
  class EagerLoader
    class_attribute :debug

    def self.load_classes_in_rails_dir(name)
      rails = Object.const_defined?('Rails') ? 'Rails'.constantize : nil
      unless rails && rails.root
        puts 'no initialized Rails application' if debug
        return false
      end
      load_classes_in_dir(rails.root.join('app', name))
    end

    def self.load_classes_in_dir(dir)
      unless File.exist?(dir)
        puts "eager-loading directory #{dir} not found" if debug
        return false
      end
      Dir.foreach(dir) do |entry|
        path = File.join(dir, entry)
        load_class_at_path(path) if path.end_with?('.rb')
        load_classes_in_dir(path) if File.directory?(path) && entry[0] != '.'
      end
    end

    def self.load_class_at_path(path)
      require path
      clazz = File.basename(path, '.*').classify.constantize
      puts "eager loaded class '#{clazz}'" if debug
    rescue LoadError, StandardError => e
      puts e.message if debug
    end
  end
end
