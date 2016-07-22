formatLocation = (name, country) ->
  text = name
  if country
    text += ", " + country
  return text

Template.locationSelect2.onRendered ->
  $(document).ready(() ->
    $("#location-select2").select2({
      multiple: true
      placeholder: "Search for locations..."
      minimumInputLength: 1
      ajax: {
        url: "http://api.geonames.org/searchJSON"
        data: (params) ->
          return {
            username: "eha_eidr"
            name: params.term
            maxRows: 10
          }
        delay: 600
        processResults: (data, params) ->
          results = []
          for loc in data.geonames
            results.push({id: loc.geonameId, text: formatLocation(loc.name, loc.countryCode), item: loc})
          return {results: results}
      }
    })
    $(".select2-container").css("width", "100%")
  )

Template.locationList.helpers
  formatLocation: (location) ->
    return formatLocation(location.name, location.countryCode)

Template.locationList.events
  "click #add-locations": (event, template) ->
    $new = $("#location-select2")
    allLocations = []
    
    for option in $new.select2("data")
      allLocations.push({
        geonameId: option.item.geonameId,
        name: option.item.name,
        countryCode: option.item.countryCode,
        latitude: option.item.latitude,
        longitude: option.item.longitude
      })
    
    Meteor.call("addEventLocations", template.data.userEvent._id, allLocations, (error, result) ->
      if not error
        $new.select2("val", "")
    )
  
  "click .remove-location": (event, template) ->
    if confirm("Do you want to delete the selected location?")
      Meteor.call("removeEventLocation", @_id)

Template.locationModal.helpers
  locationOptionText: (location) ->
    return formatLocation(location.name, location.countryCode)

Template.locationModal.events
  "click #add-suggestions": (event, template) ->
    geonameIds = []
    allLocations = []
    $("#suggested-locations-form").find("input:checked").each(() ->
      geonameIds.push($(this).val())
    )
    
    for loc in @suggestedLocations
      if geonameIds.indexOf(loc.geonameId) isnt -1
        allLocations.push(loc)
    Meteor.call("addEventLocations", @userEventId, allLocations, (error, result) ->
      Modal.hide(template)
    )