json.status :error
json.message message if defined?(message)
json.data data if defined?(data)
