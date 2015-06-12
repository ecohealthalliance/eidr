L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"

Template.eventMap.rendered = () ->

  bounds = L.latLngBounds(L.latLng(-85, -180), L.latLng(85, 180))
  
  map = L.map('event-map', 
    maxBounds: bounds
    ).setView([10, -0], 3)
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
    minZoom: 2
    maxZoom: 18
  }).addTo(map)

  instance = @
  events = @data.events.fetch()
  @allEvents = new ReactiveVar(events)
  instance.filteredEvents = new ReactiveVar(events)
  
  markers = new L.FeatureGroup()

  @autorun () ->
    map.removeLayer(markers)
    markers = new L.FeatureGroup()

    console.log instance.filteredEvents.get()
    
    for event in instance.filteredEvents.get()
      if event.locations
        name = event.eventNameVal
        eidID = event.eidID

        for location in event.locations
          latLng = [location.locationLatitude, location.locationLongitude]

          if latLng[0] isnt 'Not Found' and latLng[1] isnt 'Not Found'
            marker = L.marker(latLng, {
              icon: L.divIcon({
                className: 'map-marker-container'
                iconSize:null
                html:"""
                <div class="map-marker"></div>
                """
              })
            }).bindPopup("""
              <a href="/event/#{eidID}">#{name}</a>
            """)
            markers.addLayer(marker)

    map.addLayer(markers)


filterMap = (query) ->
  filteredEvents = _.filter Template.instance().allEvents.get(), (event) -> 
    event.eventNameVal.search(query) >= 0
  Template.instance().filteredEvents.set(filteredEvents)
clearFilters = () ->
  Template.instance().filteredEvents.set(Template.instance().allEvents.get())

Template.eventMap.events
  'keyup .map-search': (e) ->
    e.preventDefault()
    if e.keyCode == 13
      queryText = $(e.target).val()
      filterMap(queryText)
  'click .clear-search': (e) ->
    $('.map-search').val('')
    clearFilters()
