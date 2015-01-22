Template.eventMap.rendered = () ->
  L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images/"
  map = L.map('event-map').setView([0, -0], 2)
  window.map = map
  L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);
  $.getJSON("/maps/centroids.json")
    .then((centroidGeoJson)->
      L.geoJson(centroidGeoJson, {
      onEachFeature: (feature, layer) ->
        layer.bindPopup("""<a href="/event/#{feature.properties.id.substr(4)}">
          View event information
        </a>""")
      }).addTo(map)
    )
