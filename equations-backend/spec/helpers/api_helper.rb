module ApiHelper
  def post_json(url, data)
    post url, data.to_json, 'CONTENT_TYPE': 'application/json'
  end
end
