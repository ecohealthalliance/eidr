Template.tabs.rendered = () ->
  $('#tabs').tabs()


Template.statsTable.showStat = (key, object) ->
  object[key] isnt 'undefined' and object[key] isnt '' and object[key] isnt 'NF' and object[key] isnt 'NAP'

Template.statsTable.getVal = (key, object) ->
  object[key]

Template.tabs.stats = () ->
  [
    { label: 'Start Date', key: 'startDateISO' }
    { label: 'End Date', key: 'endDateISO' }
    { label: 'Host Age', key: 'hostAgeVal' }
    { label: 'Host Use', key: 'hostUseVal' }
    { label: 'Transmission Model', key: 'transmissionModelVal' }
    { label: 'Zoonotic Type', key: 'zoonoticTypePrecis' }
    { label: 'Number Infected', key: 'numberInfectedVal' }
    { label: 'Duration', key: 'durationValNum' }
    { label: 'Duration Unit', key: 'durationValUnit' }
    { label: 'Symptoms Reported', key: 'symptomsReportedVal' }
    { label: 'Sample Type', key: 'sampleTypeVal' }
    { label: 'Driver', key: 'driverVal' }
    { label: 'EID Category', key: 'eidCategoryVal' }
    { label: 'Number of Deaths', key: 'numberDeathsVal' }
    { label: 'Current Host', key: 'currentHostVal' }
    { label: 'Host', key: 'hostReportedVal' }
  ]

Template.tabs.pathogenStats = () ->
  [
    { label: 'Pathogen Type', key: 'pathogenType' }
    { label: 'Pathogen Drug Resistance', key: 'pathogenDrugResistanceVal' }
    { label: 'Pathogen Name', key: 'pathogenReportedName' }
    { label: 'Pathogen Class', key: 'pathogenClass' }
    { label: 'Pathogen Family', key: 'pathogenFamily' }
    { label: 'Pathogen Species', key: 'pathogenSpecies' }
    { label: 'Pathogen Order', key: 'pathogenOrder' }
    { label: 'Pathogen Genus', key: 'pathogenGenus' }
    { label: 'Pathogen SubSpecies', key: 'pathogenSubSpecies' }
  ]

Template.tabs.locationStats = () ->
  [
    { label: 'Place Name', key: 'locationPlaceName' }
    { label: 'Latitude', key: 'locationLatitude' }
    { label: 'Longitude', key: 'locationLongitude' }
    { label: 'City', key: 'locationCity' }
    { label: 'Subnation', key: 'locationSubnationalRegion' }
    { label: 'Nation', key: 'locationNation' }
  ]

Template.tabs.economicsStats = () ->
  [
    { label: 'Occupation', key: 'occupationVal' }
    { label: 'Age of Infected', key: 'avgAgeOfInfectedVal' }
    { label: 'Age of Infected Unit', key: 'avgAgeOfInfectedValUnit' }
    { label: 'Age of Death', key: 'avgAgeDeathVal' }
    { label: 'Age of Death Unit', key: 'avgAgeOfDeathValUnit' }
    { label: 'National GDP Per Capita', key: 'perCapitaNationalGDPInYearOfEventVal'}
    { label: 'Life Expectancy in Country', key: 'avgLifeExpectancyInCountryAndYearOfEventVal' }
  ]

Template.reference.formatAuthor = () ->
  @creators[0].lastName
