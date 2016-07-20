Template.locationList.onCreated ->
  @suggestLocations = new Mongo.Collection(null)
  
  uniqueIds = []
  suggested = []
  currentLocations = []
  
  for current in @data.locations
    currentLocations.push(current.geonameId)
  
  for article in @data.articles
    for location in article.locations
      if currentLocations.indexOf(location.geonameId) is -1 and uniqueIds.indexOf(location.geonameId) is -1
        uniqueIds.push(location.geonameId)
        @suggestLocations.insert(location)

Template.locationList.onRendered ->
  $(document).ready(() ->
    $("#new-location").select2({
      tags: true
      multiple: false
      placeholder: "Enter a geonames.org url or select a suggested location"
    })
  )

Template.locationList.helpers
  suggestLocations: () ->
    Template.instance().suggestLocations.find().fetch()

Template.locationList.events
  "click #add-location": (event, template) ->
    $input = $("#new-location")
    locationUrl = $input.val()
    Meteor.call("addEventLocation", template.data.userEvent._id, {url: locationUrl}, (error, result) ->
      if error
        if error.error is "geolocations.addEventLocation.invalid"
          alert("Invalid geonames.org url.")
      else
        template.suggestLocations.remove({url: locationUrl})
        $input.select2("val", "")
    )
  
  "click .remove-location": (event, template) ->
    if confirm("Do you want to delete the selected location?")
      removed = grid.Geolocations.findOne(@_id)
      Meteor.call("removeEventLocation", @_id, (error, result) ->
        if not error
          for article in template.data.articles
            for loc in article.locations
              if loc.geonameId is removed.geonameId
                template.suggestLocations.insert(removed)
                break
      )