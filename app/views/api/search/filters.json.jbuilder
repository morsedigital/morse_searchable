json.array!(filters) do |type, data|
  json.title type.to_s.gsub(/_/, " ")
  json.filter_by type
  json.input_type data[:input_type]
  json.filter_options(data[:collection]) do |instance|
    data[:fields].each do |field|
      json.set! field, instance.send(field)  
    end 
  end
end 