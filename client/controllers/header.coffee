Template.navLinks.events
  'click' : (e) ->
    #check event.target to see if the click was meant to open a dropdown
    if not $(e.target).hasClass("dropdown-toggle") and $('.navbar-toggle').is(':visible')
      $('.navbar-collapse').collapse('toggle')

Template.navLinks.helpers
  checkActive: (routeName) ->
    if routeName is Router.current().location.get().path.slice(1)
      'active'
