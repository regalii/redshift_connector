
module RedshiftConnector
  module RedshiftDataType
    def self.type_cast(row, manifest_file)
      row.zip(manifest_file.column_types).map do |value, type|
        next nil if (value == '' and type != 'character varing') # null becomes '' on unload

        case type
        when 'smallint', 'integer', 'bigint'
          value.to_i
        when 'numeric', 'double precision'
          value.to_f
        when 'character', 'character varying'
          value
        when 'timestamp without time zone', 'timestamp with time zone'
          Time.parse(value)
        when 'date'
          Date.parse(value)
        when 'boolean'
          value == 'true' ? true : false
        else
          raise "not support data type: #{type}"
        end
      end
    end
  end
end
