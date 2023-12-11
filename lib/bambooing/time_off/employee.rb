module Bambooing
    module TimeOff
        class Employee

        PATH = '/time_off/employee'.freeze

        class << self
                
            def pto_types(employee_id)
                payload = Client.get(path: PATH, params: { employeeId: employee_id }, headers: {})

                pto_types = payload[:policies]
                pto_types.map { |policy| policy[:categoryId] }

            rescue Client::Redirection, Client::ClientError, Client::ServerError, Client::UnknownResponse
                []
            end
        end

        end
    end
end