Template.map.rendered = () ->
  eventMap = L.map('map')
  markers = []
  
  @autorun () ->
    data = Template.currentData()
    
    for marker in markers
      eventMap.removeLayer marker
    markers = []
    
    if data.locations
      latLngs = ([location.locationLatitude, location.locationLongitude] for location in data.locations)
      if latLngs.length is 1
        eventMap.setView(latLngs[0], 4)
      else
        eventMap.fitBounds(latLngs, {padding: [15,15]})
      for location in data.locations
        latLng = [location.locationLatitude, location.locationLongitude]
        displayName = location[location.fieldUsed]

        L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', 
          attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors')
          .addTo eventMap
        circle = L.circleMarker(latLng, {
          stroke: false
          fillColor: '#1BAA4A',
          fillOpacity: 0.8,
        }).addTo(eventMap)

        circle.bindPopup displayName
        markers.push circle