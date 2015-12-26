require 'multi_json'

module Svc

  module SpecHelpers

    def json(content)
      MultiJson.dump(content, pretty: true)
    end

    def decode_json(content)
      MultiJson.load(content, symbolize_keys: true)
    end

    def expect_json
      expect(browser.last_response.headers['Content-Type']).to eq 'application/json'
    end

    def expect_200(payload = nil)
      expect(browser.last_response.body).to eq json(payload)
      expect(browser.last_response.status).to eq 200
    end

    def expect_201
      expect(browser.last_response.status).to eq 201
    end

    def expect_204
      expect(browser.last_response.status).to eq 204
      expect(browser.last_response.body).to eq ''
      expect(browser.last_response.headers['Content-Type']).to be nil
    end

    def expect_400(message = nil)
      expect(browser.last_response.body).to eq json({message: message || 'Bad request'})
      expect(browser.last_response.status).to eq 400
    end

    def expect_401(payload = {message: 'Authorization required'})
      expect(browser.last_response.body).to eq json(payload)
      expect(browser.last_response.status).to eq 401
    end

    def expect_403(message = nil)
      expect(browser.last_response.body).to eq json({message: message || 'Forbidden'})
      expect(browser.last_response.status).to eq 403
    end

    def expect_404
      expect(browser.last_response.body).to eq json({message: 'Not found'})
      expect(browser.last_response.status).to eq 404
    end

    def expect_422
      expect(browser.last_response.status).to eq 422
    end
  end

end
