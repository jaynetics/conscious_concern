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
      # silence harmless 'already initialized constant' warnings that might
      # occur due to Rails autoload having previously loaded some constants.
      silence_warnings do
        require path
        puts "eager loaded class at #{path}" if debug
      end
    rescue LoadError, StandardError => e
      return puts(e.message) if debug
      raise e unless e.message =~ /(previous definition|define multiple)/
    end
  end
end
