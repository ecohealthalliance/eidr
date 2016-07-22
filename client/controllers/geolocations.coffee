Template.locationList.onRendered ->
  $(document).ready(() ->
    $("#new-location").select2({
      multiple: true
      placeholder: "Search for a location..."
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
            optionText = loc.name
            if loc.countryCode
              optionText += ", " + loc.countryCode
              #construct 'item' so that it only has the necessary attributes
            results.push({id: loc.geonameId, text: optionText, item: loc})
          return {results: results}
      }
    })
  )

Template.locationList.helpers
  locationOptionText: (location) ->
    text = location.name
    if location.countryCode
      text += ", " + location.countryCode
    return text

Template.locationList.events
  "click #add-location": (event, template) ->
    $new = $("#new-location")
    
    for option in $new.select2("data")
      allLocations.push(option.item)
    
    console.log(allLocations)
    
    #Meteor.call("addEventLocation", template.data.userEvent._id, {url: locationUrl}, (error, result) ->
      #if error
        #if error.error is "geolocations.addEventLocation.invalid"
          #alert("Invalid geonames.org url.")
     # else
        #template.suggestLocations.remove({url: locationUrl})
        #$input.select2("val", "")
    #)
  
  "click .remove-location": (event, template) ->
    if confirm("Do you want to delete the selected location?")
      Meteor.call("removeEventLocation", @_id)