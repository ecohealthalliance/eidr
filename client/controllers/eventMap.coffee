L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"

Template.eventMap.rendered = () ->
  
  map = L.map('event-map').setView([10, -0], 3)
  
  L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    noWrap: true
  }).addTo(map);
  
  events = @data.events
  for event in events.fetch()
    if event.locations
      name = event.eventNameVal
      eidID = event.eidID

      for location in event.locations
        latLng = [location.locationLatitude, location.locationLongitude]

        if latLng[0] isnt 'NF' and latLng[1] isnt 'NF'

          circle = L.circleMarker(latLng, {
            stroke: false
            fillColor: '#1BAA4A',
            fillOpacity: 0.8,
          }).addTo(map)

          circle.bindPopup("""
            <a href="/event/#{eidID}">#{name}</a>
          """).addTo(map)
      

