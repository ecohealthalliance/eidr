Template.articles.events
  "submit #add-article": (e, template) ->
    event.preventDefault()
    article = e.target.article.value.trim()
    body = e.target.articleBody.value.trim()
    articleLocations = []
    
    if article.length isnt 0
      existingArticle = grid.Articles.find({url: article, userEventId: @userEvent._id}).fetch()
      
      if existingArticle.length is 0
        #grid.Articles.insert({
          #url: article,
          #userEventId: template.data.userEvent._id
        #})
        
        Meteor.call("getArticleLocations", body, (error, result) ->
          if result and result.data.features
            for object in result.data.features
              if object.geoname
                articleLocations.push({
                  geonameId: object.geoname.geonameid,
                  name: object.geoname.name,
                  latitude: object.geoname.latitude,
                  longitude: object.geoname.longitude,
                  countryCode: object.geoname["country code"],
                  url: "http://www.geonames.org/" + object.geoname.geonameid + "/" + object.geoname.name.toLowerCase().replace(/\s/g, "-") + ".html"
                })
          
          if articleLocations.length
            Modal.show("locationModal", {suggestedLocations: articleLocations})
        )
      #e.target.article.value = ""
      #e.target.articleBody.value = ""