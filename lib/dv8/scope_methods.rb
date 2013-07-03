module Dv8
  module ScopeMethods

    def find_one(id)
      object = find_one_from_cache(id)
      return object unless object.nil?
      set_cache do
        super(id)
      end
    end

    def find_some(ids)
      find_multiple_from_cache(ids)
    end

    def all(*args)
      ids = (args.any? ? apply_finder_options(args.first) : self).select("#{quoted_table_name}.#{primary_key}").map(&:id)
      find_multiple_from_cache(ids)
    end

    protected

    def find_multiple_from_cache(ids)
      missing_ids = {}
      results     = []

      ids.each_with_index do |id, idx|
        result = find_one_from_cache(id)
        results << result
        missing_ids[id] = idx unless result
      end

      klass.unscoped.where(:id => missing_ids.keys).each do |record|
        set_cache do
          results[missing_ids[record.id]] = record
        end
      end unless missing_ids.empty?

      results
    end

    def find_one_from_cache(id)
      content = Rails.cache.read(klass.dv8_key(id))
      return nil if content.blank?

      # useful for deploys. ensures the attribute hash is up to date with the current known schema  
      atts = {}
      klass.column_names.each do |col|
        atts[col] = content[col] || klass.columns_hash[col].default
      end
      
      klass.send(:instantiate, atts)
    end

    def set_cache
      result = yield
      atts   = result.attributes
      result.dv8_keys.each do |key|
        Rails.cache.write(key, atts)
      end
      result
    end

  end
end