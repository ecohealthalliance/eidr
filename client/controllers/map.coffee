Template.map.rendered = () ->
  latLng = [@data.locationLatitude, @data.locationLongitude]
  eventMap = L.map('map').setView(latLng, 4);
  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', 
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors')
    .addTo eventMap
  circle = L.circleMarker(latLng, {
    stroke: false
    fillColor: '#1BAA4A',
    fillOpacity: 0.8,
  }).addTo(eventMap)