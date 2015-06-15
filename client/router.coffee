Events = () ->
  @grid.Events

Fields = () ->
  @grid.Fields

Comments = () ->
  @grid.Comments
  
Comments = () ->
  @grid.Comments

Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"

Router.onRun () ->
  if Session.equals('AnalyticsJS_loaded', true)
    analytics.page @path
  @next()

Router.onAfterAction () ->
  window.scroll 0, 0

Router.route "/",
  name: 'splash'

Router.route "/about"

Router.route "/events",
  waitOn: () ->
    [
      Meteor.subscribe "fields"
    ]
  data: () ->
    fields: Fields().find({'Event table': {'$ne': '0'}})

Router.route "/event/:eidID",
  name: 'event'
  waitOn: () ->
    [
      Meteor.subscribe "event", @params.eidID
      Meteor.subscribe "fields"
      Meteor.subscribe "comments", @params.eidID
      Meteor.subscribe "references", @params.eidID
    ]
  data: () ->
    event: Events().findOne({'eidID': @params.eidID})
    comments: Comments().find({'event': @params.eidID}, {sort: {timeStamp: -1}})

Router.route "/eventMap",
  name: 'eventMap'
  waitOn: () ->
    Meteor.subscribe "events"
    Meteor.subscribe "locations"
    Meteor.subscribe "fields"
  data: () ->
    events: Events()
    transmissionTypes: Fields().findOne({"displayName" : "Event Transmission"})

Router.route "/download",
  name: 'download',
  onBeforeAction: () ->
    unless Meteor.userId()
      @redirect '/sign-in'
    @next()
  action: () ->
    @render('preparingDownload')
    controller = @
    Meteor.call('download', (err, result) ->
      unless err
        csvData = "data:text/csv;charset=utf-8," + result.csv
        jsonData = "data:application/json;charset=utf-8," + result.json
        controller.render('download', 
          data:
            jsonData: encodeURI(jsonData)
            csvData: encodeURI(csvData)
        )
    )

Router.route "/variable-definitions",
  name: 'varDefs',
  waitOn: () ->
    [
      Meteor.subscribe "fields"
    ]
  data: () ->
    fields: Fields().find({'tab': {'$ne': ''}, 'webVariable': {'$ne': '0'}})
