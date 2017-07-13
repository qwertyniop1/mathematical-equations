module Sinatra
  module MultiRoute
    def route(methods, url = '', options = {}, &block)
      methods.each { |method| send(method, url, options, &block) }
    end

    def get_or_post(url, options = {}, &block)
      get(url, options, &block)
      post(url, options, &block)
    end
  end
end
