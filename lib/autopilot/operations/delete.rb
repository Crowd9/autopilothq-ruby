module Autopilot
  module Operations
    module Delete
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def delete(id, opts = {}, client = Autopilot.shared_client)
          opts = Utils.serialize_values(opts)
          json = client.delete_json(find_path(id), opts)
          new(json)
        end

        def find_path(id = nil)
          single_path = "/#{record_key.to_s}"
          id ? "#{single_path}/#{id}" : single_path
        end
      end
    end
  end
end