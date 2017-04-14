data = JSON.parse(IO.read(Rails.root.join('public/actors.json'))).map { |a| a.except('objectID') }
Actor.create(data)
