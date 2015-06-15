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
  instance.eventsQuery = new ReactiveVar({})
  window.events = @data.events

  markers = new L.FeatureGroup()

  @autorun () ->
    map.removeLayer(markers)
    markers = new L.FeatureGroup()
    query = instance.eventsQuery.get()

    if _.isObject query
      filteredEvents = instance.data.events.find(query).fetch()
    else 
      map.removeLayer(markers)
      return

    for event in filteredEvents
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
              <a href="/event/#{eidID}">#{name}
              </a>
            """)
            markers.addLayer(marker)

    map.addLayer(markers)

filterMap = (userSearchText, zoonosis, eventTransmission) ->
  mapInstance = Template.instance().view.parentView._templateInstance
  zoonoticQuery = []
  eventTransmissionQuery = []
  if userSearchText and zoonosis.length and eventTransmission.length
    nameQuery = []
    searchWords = userSearchText.split(' ')
    _.each searchWords, ()-> nameQuery.push {eventNameVal: new RegExp(userSearchText, 'i')}
    _.each zoonosis, (value) -> zoonoticQuery.push({zoonoticVal: new RegExp(value, 'i')})
    _.each eventTransmission, (value) -> eventTransmissionQuery.push({eventTransmissionVal: new RegExp(value, 'i')})
    mapInstance.eventsQuery.set({ $and: [ {$or: nameQuery}, {$or: zoonoticQuery}, {$or: eventTransmissionQuery} ] })
  else if zoonosis.length and eventTransmission.length
    _.each zoonosis, (value) -> zoonoticQuery.push({zoonoticVal: new RegExp(value, 'i')})
    _.each eventTransmission, (value) -> eventTransmissionQuery.push({eventTransmissionVal: new RegExp(value, 'i')})
    mapInstance.eventsQuery.set({$and: [{$or: zoonoticQuery}, {$or: eventTransmissionQuery}]})
  else 
    mapInstance.eventsQuery.set(false)

clearSearch = () ->
  filterMap(false, getChecked('zoonosis'), getChecked('category'))

clearAllFilters = () ->
  Template.instance().filteredEvents.set(Template.instance().allEvents.get())

getChecked = (type) ->
  _.map $('.'+type+':checked').get(), (input) -> input.value

checkAll = (state, target) ->
  $('.category').each () -> $(this).prop("checked", state)
  filterMap($('.map-search').val() || false, getChecked('zoonosis'), getChecked('category'))
  $(target).toggleClass 'uncheck-all check-all'

Template.mapFilters.helpers
  getCategories: () ->
    categories = []
    for key of @transmissionTypes.dropdownExplanations
      categories.push(key)
    categories.push("Not Found")
    categories

Template.mapFilters.events
  'click .filter' : (e) ->
    $('.filter').toggleClass('open')
    $('.filters-wrap').toggleClass('hidden')

  'change input[type=checkbox]': (e) ->
    filterMap($('.map-search').val() || false, getChecked('zoonosis'), getChecked('category'))

  'keyup .map-search': (e) ->
    e.preventDefault()
    if $(e.target).val() == ''
      clearSearch()
    if e.keyCode == 13
      userSearchText = $(e.target).val()
      filterMap(userSearchText, getChecked('zoonosis'), getChecked('category'))
  'click .clear-search': (e) ->
    $('.map-search').val('')
    clearSearch()
  'click .check': (e) ->
    if $(e.target).hasClass('check-all')
      checkAll(true, e.target)
    else 
      checkAll(false, e.target)

