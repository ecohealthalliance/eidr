getEvent = () =>
  @grid.Events.findOne({eidID: Session.get('eidID')})

Template.map.rendered = () ->
  w = 400
  h = 230

  eid = getEvent()?.eidID

  projection = d3.geo.mercator()
    .translate([w/2, h/2])
    .scale([50])

  path = d3.geo.path()
    .projection(projection)
    .pointRadius(4)

  svg = d3.select('.map')
    .append('svg')
    .attr('width', w)
    .attr('height', h)

  d3.json '/oceans.json', (json) ->
    d3.json '/centroids.json', (eids) ->

      for feature in eids.features
        if feature.properties.id is 'HED_' + eid
          json.features.push(feature)
          break

      svg.selectAll("path")
        .data(json.features)
        .enter()
        .append("path")
        .attr("d", path)
        .style "fill", (d) ->
            type = d.geometry.type
            if type is "Point"
              return "crimson"
            else
              return "steelblue"
