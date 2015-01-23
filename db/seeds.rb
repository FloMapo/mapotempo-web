mapbox = Layer.create!(name: "MapBox Street", url: "http://{s}.tiles.mapbox.com/v3/examples.map-i87786ca/{z}/{x}/{y}.png", urlssl: "https://{s}.tiles.mapbox.com/v3/examples.map-i87786ca/{z}/{x}/{y}.png", attribution: "Tiles by MapBox")
Layer.create!(name: "Mapnik", url: "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", urlssl: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", attribution: "Tiles by OpenStreetMap")
Layer.create!(name: "Mapnik-fr", url: "http://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png", urlssl: "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png", attribution: "Tiles by OpenStreetMap-France")
Layer.create!(name: "Mapnik B&W", url: "http://{s}.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png", urlssl: "https://{s}.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png", attribution: "Tiles by Wikimedia")
Layer.create!(name: "MapQuest", url: "http://otile2.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png", urlssl: "https://otile2-s.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png", attribution: "Tiles by MapQuest")
Layer.create!(name: "Stamen B&W", url: "http://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png", urlssl: "https://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.png", attribution: "Tiles by Stamen Design")
osrm = Router.create!(name: "project-osrm.org", url:"http://router.project-osrm.org")
customer = Customer.create!(name: "Toto", max_vehicles: 3, router: osrm, test: true)
admin = User.create!(email: "admin@admin.com", password: "123456789", admin: true)
fred = User.create!(email: "user@user.com", password: "123456789", layer: mapbox, customer: customer)
toto = User.create!(email: "toto@toto.com", password: "123456789", customer: customer)
store = Store.create!(name: "l1", street: "Place Picard", postalcode: "33000", city: "Bordeaux", lat: 44.81673, lng: -0.55115, customer: customer)
Vehicle.create!(capacity: 100, customer: customer, name: "Renault Kangoo", store_start: store, store_stop: store)
Vehicle.create!(capacity: 100, customer: customer, name: "Fiat Vito", store_start: store, store_stop: store)
Destination.create!(name: "l1", street: "Place Picard", postalcode: "33000", city: "Bordeaux", lat: 44.84512, lng: -0.578, quantity: 1, customer: customer)
Destination.create!(name: "l2", street: "Rue Esprit des Lois", postalcode: "33000", city: "Bordeaux", lat: 44.83395, lng: -0.56545, quantity: 1, customer: customer)
Destination.create!(name: "l3", street: "Rue de Nuits", postalcode: "33000", city: "Bordeaux", lat: 44.84272, lng: -0.55013, quantity: 1, customer: customer)
Destination.create!(name: "l4", street: "Rue de New York", postalcode: "33000", city: "Bordeaux", lat: 44.86576, lng: -0.57577, quantity: 1, customer: customer)
Tag.create!(label: "lundi", customer: customer)
Tag.create!(label: "jeudi", customer: customer)
Tag.create!(label: "frigo", customer: customer)
