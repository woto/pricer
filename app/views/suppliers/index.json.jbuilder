json.array!(@suppliers) do |supplier|
  json.extract! supplier, :id, :title, :notes
  json.url supplier_url(supplier, format: :json)
end
