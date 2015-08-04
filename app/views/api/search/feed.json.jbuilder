if feed && feed.any?
  json.array!(feed) do |item|
    json.id item.id
    fields[:main].each do |field|
      json.set! field, item.send(field)
    end
    fields.each do |association, attrs|
      if association != :main
        attrs[:fields].each do |field|
          json.set! association, item.send(association).send(field) if item.send(association)
        end
      end
    end
    json.filters do 
      fields.each do |association, attrs|
        if association != :main
          json.set! association, item.send(association).id if item.send(association)
        end
      end
    end
  end
end