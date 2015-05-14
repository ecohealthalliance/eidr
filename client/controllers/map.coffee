Template.map.rendered = () ->
  eventMap = L.map('map')
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
  }).addTo eventMap
  markers = []
  
  @autorun () ->
    data = Template.currentData()
    
    for marker in markers
      eventMap.removeLayer marker
    markers = []
    
    if data.locations
      latLngs = ([location.locationLatitude, location.locationLongitude] for location in data.locations)
      latLngs = _.filter(latLngs, (latLng) ->
        latLng[0] isnt 'Not Found' and latLng[1] isnt 'Not Found'
      )
      if latLngs.length is 1
        eventMap.setView(latLngs[0], 4)
      else
        eventMap.fitBounds(latLngs, {padding: [15,15]})
      for location in data.locations
        latLng = [location.locationLatitude, location.locationLongitude]
        if latLng[0] isnt 'Not Found' and latLng[1] isnt 'Not Found'
          displayName = location[location.fieldUsed]


          circle = L.circleMarker(latLng, {
            stroke: false
            fillColor: '#1BAA4A',
            fillOpacity: 0.8,
          }).addTo(eventMap)

          circle.bindPopup displayName
          markers.push circle