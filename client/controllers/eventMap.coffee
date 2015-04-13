L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"

Template.eventMap.rendered = () ->
  
  map = L.map('event-map').setView([10, -0], 3)
  
  L.tileLayer('//otile{s}.mqcdn.com/tiles/1.0.0/{type}/{z}/{x}/{y}.png', {
    attribution: """
    Map Data &copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors,
    Tiles &copy; <a href="http://www.mapquest.com/" target="_blank">MapQuest</a>
    <img src="http://developer.mapquest.com/content/osm/mq_logo.png" />
    """
    subdomains: '1234'
    type: 'osm'
    maxZoom: 18
  }).addTo(map);
  
  events = @data.events
  for event in events.fetch()
    if event.locations
      name = event.eventNameVal
      eidID = event.eidID

      for location in event.locations
        latLng = [location.locationLatitude, location.locationLongitude]

        if latLng[0] isnt 'Not Found' and latLng[1] isnt 'Not Found'

          circle = L.circleMarker(latLng, {
            stroke: false
            fillColor: '#1BAA4A',
            fillOpacity: 0.8,
          }).addTo(map)

          circle.bindPopup("""
            <a href="/event/#{eidID}">#{name}</a>
          """).addTo(map)
      

