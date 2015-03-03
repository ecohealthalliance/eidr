references = () =>
  @grid.References

Template.references.getReferences = () ->
  references().getReferences(@event.eidID)