Events = () ->
  @grid.Events

Fields = () ->
  @grid.Fields

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

Router.route "/eventMap",
  name: 'eventMap'
  waitOn: () ->
    Meteor.subscribe "locations"
  data: () ->
    events: Events().find()
    
Router.route "/eidr.json",
  name: 'downloadJSON',
  onBeforeAction: () ->
    unless Meteor.userId()
      @redirect '/sign-in'
    @next()
  action: () ->
    @render('preparingDownload')
    controller = @
    Meteor.call('downloadJSON', (err, result) ->
      content = "data:application/json;charset=utf-8," + result
      controller.render('jsonDownload', {data: encodeURI(content)})
    )

Router.route "/eidr.csv",
  name: 'downloadCSV',
  onBeforeAction: () ->
    unless Meteor.userId()
      @redirect '/sign-in'
    @next()
  action: () ->
    @render('preparingDownload')
    controller = @
    Meteor.call('downloadCSV', (err, result) ->
      content = "data:text/csv;charset=utf-8," + result
      controller.render('csvDownload', {data: encodeURI(content)})
    )
