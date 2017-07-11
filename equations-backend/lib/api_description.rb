def api_description(name = 'index')
  file_path = File.join __dir__, "description/#{name}.json"
  File.open(file_path, &:read)
rescue
  nil
end
