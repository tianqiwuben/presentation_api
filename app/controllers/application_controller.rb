class ApplicationController < ActionController::API

    def api_success(data = nil)
        render json: { success: true, payload: data}
    end

    def api_fail(error = nil, status = 400)
        render json: { success: false, error: error}, status: status
    end
    

end
