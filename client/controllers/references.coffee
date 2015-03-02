references = () =>
  @grid.References

Template.reference.log = (d) ->
  console.log d

Template.references.getReferences = () ->
  references().getReferences(@event.eidID)