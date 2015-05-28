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
  onBeforeAction: () ->
    $('.nav li').removeClass('active')
    @next()


Router.route "/eventMap",
  name: 'eventMap'
  waitOn: () ->
    Meteor.subscribe "locations"
  data: () ->
    events: Events().find({'eidVal': "1"})

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
    fields: Fields().find()
