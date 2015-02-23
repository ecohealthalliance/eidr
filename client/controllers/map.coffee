Template.map.rendered = () ->
  w = 400
  h = 230

  eid = @data.eidID

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
    .style('background-color', 'steelblue')

  world = svg.append('g')
  eventArea = svg.append('g')


  d3.json '/world-110m2.json', (error, topology) ->
    world.selectAll("path")
      .data(topojson.object(topology, topology.objects.countries).geometries)
    .enter()
      .append("path")
      .attr("d", path)
      .style("fill", "beige")

    d3.json "/maps/HED_#{eid}.json", (featureCollection) ->
      eventArea.selectAll("path")
        .data(featureCollection.features)
        .enter()
        .append("path")
        .attr("d", path)
        .style "fill", "crimson"
        .style "stroke", "crimson"
        .style "stroke-width", "1.5px"

      feature = featureCollection.features[0]
      zoomFactor = .02
      if feature.geometry.type is 'MultiPolygon'
        zoomFactor = .05
      bounds = path.bounds(feature)
      dx = bounds[1][0] - bounds[0][0]
      dy = bounds[1][1] - bounds[0][1]
      x = (bounds[0][0] + bounds[1][0]) / 2
      y = (bounds[0][1] + bounds[1][1]) / 2
      scale = zoomFactor / Math.max(dx / w, dy / h)
      translate = [w / 2 - scale * x, h / 2 - scale * y]

      world.attr("transform", "translate(" + translate + ")scale(" + scale + ")")
      eventArea.style("stroke-width", 1.5 / scale + "px")
        .attr("transform", "translate(" + translate + ")scale(" + scale + ")")

      zoom = d3.behavior.zoom()
        .scale(scale)
        .translate(translate)
        .on "zoom", () ->
          world.attr "transform", "translate(" + d3.event.translate.join(",") + ")scale(" + d3.event.scale + ")"
          world.selectAll("path")
            .attr "d", path.projection(projection)
          eventArea.attr "transform", "translate(" + d3.event.translate.join(",") + ")scale(" + d3.event.scale + ")"
          eventArea.selectAll("path")
            .attr "d", path.projection(projection)
            .attr "stroke-width", 1.5 / d3.event.scale + "px"

      svg.call(zoom)
