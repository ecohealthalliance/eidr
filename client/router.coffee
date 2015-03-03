Events = () ->
  @grid.Events

Fields = () ->
  @grid.Fields

removePopovers = () ->
  $('.popover').remove()

Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"

Router.onRun () ->
  if Session.equals('AnalyticsJS_loaded', true)
    analytics.page @path
  @next()

Router.onBeforeAction(removePopovers)

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
      Meteor.subscribe "references", @params.eidID
    ]
  data: () ->
    event: Events().findOne({'eidID': @params.eidID})


Router.route "/eventMap",
  name: 'eventMap'
  waitOn: () ->
    Meteor.subscribe "locations"
  data: () ->
    events: Events().find()
