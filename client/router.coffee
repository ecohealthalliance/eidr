Events = () ->
  @grid.Events

Fields = () ->
  @grid.Fields

Router.configure
  layoutTemplate: "layout"

Router.onRun () ->
  if Session.equals('AnalyticsJS_loaded', true)
    analytics.page @path

Router.map () ->

  @route "splash",
    path: "/"
    where: "client"

  @route "about",
    path: "/about"
    where: "client"

  @route "events",
    path: "/events"
    where: "client"
    waitOn: () ->
      [
        Meteor.subscribe "events"
        Meteor.subscribe "fields"
      ]
    data: () ->
      eventList: Events().find({'eidVal': '1'})
      fields: Fields().find({'Event table': {'$ne': '0'}})

  @route "event",
    path: "/event/:eidID"
    where: "client"
    waitOn: () ->
      [
        Meteor.subscribe "event", @params.eidID
        Meteor.subscribe "fields"
      ]
    data: () ->
      event: Events().findOne({'eidID': @params.eidID})
