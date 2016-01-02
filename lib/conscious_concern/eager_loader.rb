module ConsciousConcern
  #
  # Recursively finds Ruby Classes in a given directory.
  #
  class EagerLoader
    class_attribute :debug

    def self.load_classes_in_rails_dirs(*dir_names)
      rails = Object.const_defined?('Rails') ? 'Rails'.constantize : nil
      unless rails && rails.root
        puts 'no initialized Rails application' if debug
        return false
      end
      load_classes_in_engine_dirs(rails, *dir_names)
    end

    def self.load_classes_in_engine_dirs(engine, *dir_names)
      dir_names.each do |dir_name|
        load_classes_in_dir(engine.root.join('app', dir_name))
      end
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
      # Silence harmless 'already initialized constant' warnings that might
      # occur due to Rails autoload having previously loaded some constants.
      # Use load if require returns false for reloads in Rails development.
      silence_warnings do
        load path
        puts "eager loaded class at #{path}" if debug
      end
    rescue LoadError, StandardError, TypeError => e
      return puts(e.message) if debug
      raise e if e.message !~ /(previous def|define multiple|class mismatch)/
    end
  end
end
