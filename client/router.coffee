Events = () ->
  @grid.Events

Router.configure
  layoutTemplate: "layout"

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
      Meteor.subscribe "events"

  @route "event",
    path: "/event/:eidID"
    where: "client"
    waitOn: () ->
      [
        Meteor.subscribe "events"
        Meteor.subscribe "fields"
      ]
    onBeforeAction: () ->
      Session.set('eidID', @params.eidID)
    onStop: () ->
      Session.set('eidID', null)
