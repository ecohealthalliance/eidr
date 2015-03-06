Events = () ->
  @grid.Events

Fields = () ->
  @grid.Fields

download = () ->
  
  unless @userId
    throw new Meteor.Error(403, "Must be signed in to download data")

  fields = Fields().find().fetch()
  events = Events().find({eidVal: "1"}, {sort: {eidID: 1}}).fetch()

  # csv
  headerRow = (field.displayName for field in fields).join(",")
  
  csvRows = [headerRow]
  for event in events
    csvRows.push ("\"#{event[field.spreadsheetName] or ''}\"" for field in fields).join(",")

  csvData = csvRows.join("\n")

  # json
  eventsOutput = []
  for event in events
      eventObject = {}
      for field in fields
          if event[field.spreadsheetName]
              eventObject[field.displayName] = event[field.spreadsheetName]
      
      eventsOutput.push eventObject
      
  jsonData = JSON.stringify(eventsOutput)
  
  csv: csvData
  json: jsonData
    
Meteor.methods
  download: download