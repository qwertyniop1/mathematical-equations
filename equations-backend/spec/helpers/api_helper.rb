module ApiHelper
  def post_json(url, data, headers = {})
    headers['CONTENT_TYPE'] = 'application/json'
    post url, data.to_json, headers
  end
end
