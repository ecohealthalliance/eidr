Template.navLinks.events
  'click' : (e) ->
    if $('.navbar-toggle').is(':visible')
      $('.navbar-collapse').collapse('toggle')

    $(".nav li").removeClass("active")

Template.navLinks.helpers
  checkActive: (routeName) ->
    if routeName is Router.current().location.get().path.slice(1)
      'active'