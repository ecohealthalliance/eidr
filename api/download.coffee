Events = () ->
  @grid.Events

Fields = () ->
  @grid.Fields

signInRedirect = () ->
  if !Meteor.user()
    @redirect('/sign-in')

downloadCSV = () ->
  @response.setHeader('Content-Type', 'text/csv')
  
  fields = Fields().find().fetch()
  events = Events().find({eidVal: "1"}, {sort: {eidID: 1}}).fetch()

  headerRow = (field.displayName for field in fields).join(",")
  
  csvRows = [headerRow]
  for event in events
    csvRows.push ("\"#{event[field.spreadsheetName] or ''}\"" for field in fields).join(",")

  @response.end(csvRows.join("\n"))

Router.route "/sicki-grid.csv", onBeforeAction: signInRedirect, downloadCSV, {where: 'server'}


downloadJSON = () ->
  @response.setHeader('Content-Type', 'application/json')
  
  fields = Fields().find().fetch()
  events = Events().find({eidVal: "1"}, {sort: {eidID: 1}}).fetch()
  
  eventsOutput = []
  for event in events
      eventObject = {}
      for field in fields
          if event[field.spreadsheetName]
              eventObject[field.displayName] = event[field.spreadsheetName]
      
      eventsOutput.push eventObject
      
  @response.end(JSON.stringify(eventsOutput))
    
Router.route "sicki-grid.json", onBeforeAction: signInRedirect, downloadJSON, {where: 'server'}