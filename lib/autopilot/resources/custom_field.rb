module Autopilot
  class CustomField < Resource
    class << self
      def singleton_resource?
        true
      end
    end

    include Operations::Retrieve
  end
end
