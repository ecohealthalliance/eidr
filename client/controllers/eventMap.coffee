L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"

Template.eventMap.rendered = () ->

  southWest = L.latLng(-85, -180)
  northEast = L.latLng(85, 180)
  bounds = L.latLngBounds(southWest, northEast)
  
  map = L.map('event-map', maxBounds: bounds).setView([10, -0], 3)
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
    noWrap: true
    minZoom: 3
    maxZoom: 18
  }).addTo map

  map.fitBounds(bounds)

  events = @data.events
  for event in events.fetch()
    if event.locations
      name = event.eventNameVal
      eidID = event.eidID

      for location in event.locations
        latLng = [location.locationLatitude, location.locationLongitude]

        if latLng[0] isnt 'Not Found' and latLng[1] isnt 'Not Found'

          L.marker(latLng, {
            icon: L.divIcon({
              className: 'map-marker-container'
              iconSize:null
              html:"""
              <div class="map-marker"></div>
              """
            })
          }).bindPopup("""
            <a href="/event/#{eidID}">#{name}</a>
          """).addTo(map)

