Template.map.rendered = () ->
  eventMap = L.map('map')
  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', 
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors')
  .addTo eventMap
  markers = []
  
  @autorun () ->
    data = Template.currentData()
    
    for marker in markers
      eventMap.removeLayer marker
    markers = []
    
    if data.locations
      latLngs = ([location.locationLatitude, location.locationLongitude] for location in data.locations)
      latLngs = _.filter(latLngs, (latLng) ->
        latLng[0] isnt 'NF' and latLng[1] isnt 'NF'
      )
      if latLngs.length is 1
        eventMap.setView(latLngs[0], 4)
      else
        eventMap.fitBounds(latLngs, {padding: [15,15]})
      for location in data.locations
        latLng = [location.locationLatitude, location.locationLongitude]
        if latLng[0] isnt 'NF' and latLng[1] isnt 'NF'
          displayName = location[location.fieldUsed]


          circle = L.circleMarker(latLng, {
            stroke: false
            fillColor: '#1BAA4A',
            fillOpacity: 0.8,
          }).addTo(eventMap)

          circle.bindPopup displayName
          markers.push circle