json.array!(@list) do |list|
  json.extract! list, :id, :title, :status, :deadline
  json.url list_url(list, format: :json)
end
