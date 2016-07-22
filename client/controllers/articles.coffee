Template.articles.events
  "submit #add-article": (e, template) ->
    event.preventDefault()
    article = e.target.article.value.trim()
    body = e.target.articleBody.value.trim()
    
    if article.length isnt 0
      existingArticle = grid.Articles.find({url: article, userEventId: @userEvent._id}).fetch()
      
      if existingArticle.length is 0
        grid.Articles.insert({
          url: article,
          userEventId: template.data.userEvent._id
        })
        
        e.target.article.value = ""
        e.target.articleBody.value = ""
        
        if body.length
          articleLocations = []
          
          existingLocations = []
          
          for loc in @locations
            existingLocations.push(loc.geonameId)
          
          Modal.show("loadingModal")
          
          Meteor.call("getArticleLocations", body, (error, result) ->
            if result and result.data.features
              for object in result.data.features
                if object.geoname
                  if existingLocations.indexOf(object.geoname.geonameid) is -1
                    articleLocations.push({
                      geonameId: object.geoname.geonameid,
                      name: object.geoname.name,
                      latitude: object.geoname.latitude,
                      longitude: object.geoname.longitude,
                      countryCode: object.geoname["country code"],
                      url: Meteor.call("generateGeonamesUrl", object.geoname.geonameid)
                    })
            Modal.hide()
            if articleLocations.length
              Modal.show("locationModal", {userEventId:template.data.userEvent._id, suggestedLocations: articleLocations})
          )