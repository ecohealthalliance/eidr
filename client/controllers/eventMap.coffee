L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"

Template.eventMap.rendered = () ->
  
  map = L.map('event-map').setView([10, -0], 3)
  
  L.tileLayer('//{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
    attribution: """Map tiles by <a href="http://cartodb.com/attributions#basemaps">CartoDB</a>, under <a href="https://creativecommons.org/licenses/by/3.0/">CC BY 3.0</a>. Data by <a href="http://www.openstreetmap.org/">OpenStreetMap</a>, under ODbL.
    <br>
    CRS:
    <a href="http://wiki.openstreetmap.org/wiki/EPSG:3857" >
    EPSG:3857
    </a>,
    Projection: Spherical Mercator""",
    subdomains: 'abcd',
    type: 'osm'
    maxZoom: 18
  }).addTo map

  events = @data.events
  for event in events.fetch()
    if event.locations
      name = event.eventNameVal
      eidID = event.eidID

      for location in event.locations
        latLng = [location.locationLatitude, location.locationLongitude]

        if latLng[0] isnt 'Not Found' and latLng[1] isnt 'Not Found'

          circle = L.circleMarker(latLng, 
            radius: 5
            stroke: false
            fillColor: '#1BAA4A'
            fillOpacity: 0.8
          ).addTo map

          circle.bindPopup("""
            <a href="/event/#{eidID}">#{name}</a>
          """).addTo(map)
      

