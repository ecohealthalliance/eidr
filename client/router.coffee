Events = () ->
  @grid.Events

Fields = () ->
  @grid.Fields

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
    ]
  data: () ->
    event: Events().findOne({'eidID': @params.eidID})
