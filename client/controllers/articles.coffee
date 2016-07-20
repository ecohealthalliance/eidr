Template.articles.events
  "submit #add-article": (e) ->
    event.preventDefault()
    article = e.target.article.value.trim()
    response = JSON.parse(e.target.scraperResponse.value.trim())
    articleLocations = []
    
    if article.length isnt 0
      existingArticle = grid.Articles.find({url: article, userEventId: @userEvent._id}).fetch()
      
      if existingArticle.length is 0
        if response.features
          for object in response.features
            if object.geoname
              articleLocations.push({
                geonameId: object.geoname.geonameid,
                name: object.geoname.name,
                url: "http://www.geonames.org/" + object.geoname.geonameid + "/" + object.geoname.name.toLowerCase().replace(/\s/g, "-") + ".html"
              })
        
        grid.Articles.insert({
          url: article,
          userEventId: @userEvent._id,
          locations: articleLocations
        })
      #need to add article locations to the suggested locations collection, but how?
      e.target.article.value = ''