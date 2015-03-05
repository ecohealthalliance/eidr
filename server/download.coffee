Events = () ->
  @grid.Events

Fields = () ->
  @grid.Fields

downloadCSV = () ->
  
  unless @userId
    throw new Meteor.Error(403, "Must be signed in to download data")

  fields = Fields().find().fetch()
  events = Events().find({eidVal: "1"}, {sort: {eidID: 1}}).fetch()

  headerRow = (field.displayName for field in fields).join(",")
  
  csvRows = [headerRow]
  for event in events
    csvRows.push ("\"#{event[field.spreadsheetName] or ''}\"" for field in fields).join(",")

  csvRows.join("\n")


downloadJSON = () ->
  unless @userId
    throw new Meteor.Error(403, "Must be signed in to download data")
  
  fields = Fields().find().fetch()
  events = Events().find({eidVal: "1"}, {sort: {eidID: 1}}).fetch()
  
  eventsOutput = []
  for event in events
      eventObject = {}
      for field in fields
          if event[field.spreadsheetName]
              eventObject[field.displayName] = event[field.spreadsheetName]
      
      eventsOutput.push eventObject
      
  JSON.stringify(eventsOutput)
    
Meteor.methods
  downloadCSV: downloadCSV
  downloadJSON: downloadJSON