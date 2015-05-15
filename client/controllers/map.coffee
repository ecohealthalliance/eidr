Template.map.rendered = () ->
  eventMap = L.map('map')
  L.tileLayer('//otile{s}.mqcdn.com/tiles/1.0.0/{type}/{z}/{x}/{y}.png', {
    attribution: """
    Map Data &copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors,
    Tiles &copy; <a href="http://www.mapquest.com/" target="_blank">MapQuest</a>
    <img src="http://developer.mapquest.com/content/osm/mq_logo.png" />
    """
    subdomains: '1234'
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