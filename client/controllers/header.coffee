Template.navLinks.events
  'click' : (e) ->
    if $('.navbar-toggle').is(':visible')
      $('.navbar-collapse').collapse('toggle')

Template.navLinks.helpers
  checkActive: (routeName) ->
    if routeName is Router.current().location.get().path.slice(1) or routeName is Router.current().route.getName()
      'active'