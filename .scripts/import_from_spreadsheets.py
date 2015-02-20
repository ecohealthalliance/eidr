import re, urllib, urllib2, csv
import pymongo
from bson.objectid import ObjectId
from pyzotero import zotero
import config


class Client(object):
  # Based on https://gist.github.com/cspickert/1650271
	def __init__(self, email, password):
		super(Client, self).__init__()
		self.email = email
		self.password = password
		self.token = None

	def _get_auth_token(self, email, password, source, service):
		url = "https://www.google.com/accounts/ClientLogin"
		params = {
			"Email": email, "Passwd": password,
			"service": service,
			"accountType": "HOSTED_OR_GOOGLE",
			"source": source
		}
		req = urllib2.Request(url, urllib.urlencode(params))
		return re.findall(r"Auth=(.*)", urllib2.urlopen(req).read())[0]

	def get_auth_token(self):
		if self.token:
			return self.token
		source = type(self).__name__
		self.token = self._get_auth_token(self.email, self.password, source, service="wise")
		return self.token

	def download(self, spreadsheet_id, gid=0, format="csv"):
		url_format = "https://spreadsheets.google.com/feeds/download/spreadsheets/Export?key=%s&exportFormat=%s&gid=%i"
		headers = {
			"Authorization": "GoogleLogin auth=" + self.get_auth_token(),
			"GData-Version": "3.0"
		}
		req = urllib2.Request(url_format % (spreadsheet_id, format, gid), headers=headers)
		return urllib2.urlopen(req, timeout=120)

def import_fields(file, db):
  fields = db.fields
  tsv = csv.reader(file, delimiter='\t')
  columns = None
  order = 0
  for row in tsv:
    if not columns:
      columns = row
    else:
      d = dict(zip(columns, row))
      d['_id'] = str(ObjectId())
      d['order'] = order
      order = order + 1
      parsedDropdownExplanations = dict()
      dropdownExplanations = d['dropdownExplanations'].split(",")
      for exp in dropdownExplanations:
        if ":" in exp:
          key, val = exp.strip().split(":")
          parsedDropdownExplanations[key] = val
      d['dropdownExplanations'] = parsedDropdownExplanations
      fields.insert(d)

def import_events(file, db):
  events = db.events
  tsv = csv.reader(file, delimiter='\t')
  columns = None
  for row in tsv:
    if not columns:
      columns = row
    else:
      d = dict(zip(columns, row))
      if len(row) != len(columns):
        print "%s %s row probably broken" % (row[0], row[2])
      d['_id'] = str(ObjectId())
      events.insert(d)

def import_other_sheet(file, db):
  events = db.events
  tsv = csv.reader(file, delimiter='\t')
  columns = None
  for row in tsv:
    if not columns:
      columns = row
    else:
      d = dict(zip(columns, row))
      e = events.find_one({'eventName': d['eventName']})
      if e is None:
        print "No event for %s" % d['eventName']
      else:
        events.update({'_id': e['_id']}, {'$set': d})

def find_zotero_ref(ref, zoteroItems):
  for item in zoteroItems:
    try:
      if not item.get('rights'):
        item = item.get('data')
      if item.get('rights') and (int(ref) == int(item.get('rights'))):
        return item
    except Exception as e:
      return None

REFERENCE_FIELDS = [
  'refEIDCategory',
  'refAbstract',
  'refDriver',
  'refDiseaseValPrecis',
  'refPubDateISO',
  'refStartDate',
  'refEndDate',
  'refDuration',
  'refNumberInfected',
  'refNumDeaths',
  'refEventTransmissionVal',
  'refGeneralTransmissionVal',
  'refReportedSymptomsVal',
  'refSampleType',
  'refReportedZoonoticType',
  'refHostAge',
  'refHostUse',
  'refInitiallyReportedPathogenNameVal',
  'refPathogenSpecies',
  'refHost',
  'refInitiallyReportedHostVal',
  'refLocationLocationName',
  'refLocationName',
  'refLocationCity',
  'refLocationSubnationalRegion',
  'refLocationNation',
  'occupationRef',
  'refAvgAgeOfInfectedrefAvgAgeDeath',
  'refNumHospitalized',
  'refPerCapitaNationalGDPInYearOfEvent',
  'refAvgLifeExpectancyInCountryAndYearOfEvent',
]

REFS_TO_REPLACE = {
  '^NIH$': 1087,
  '^CDC$': 1088,
  '.*worldbank\.org.*': 1089,
  '^http\:\/\/www\.ncbi\.nlm\.nih\.gov$': 1090,
}

def import_refs(db, zot):
  items = []
  offset = 0
  while offset <= zot.num_items():
    items += zot.top(start=offset, limit=50)
    offset += 50
  
  events = db.events
  for event in events.find():
    eidID = event.get('eidID')

    refStrings = []
    for refField in REFERENCE_FIELDS:
      if event.get(refField):
        for ref in event.get(refField).split(','):
          if not ref.strip() in refStrings:
            refStrings.append(ref.strip())

    references = []
    for ref in refStrings:
      if re.match('^\{?[\d]{1,4}\}?\)?$', ref):
        zotRef = find_zotero_ref(ref.replace('{', '').replace('}', ''), items)
        if zotRef:
          references.append(zotRef)
        else:
          if len(references) > 0 and type(references[-1]) != dict and re.match("^[\d]{4}\}?\)?$", ref):
            # could be date to reattach to the previous ref
            references[-1] = "%s, %s" % (references[-1], ref)
          else:
            print "%s: no zotero reference for %s" % (eidID, ref)
      else:
        matched = False
        for refPattern, zoteroId in REFS_TO_REPLACE.iteritems():
          if re.match(refPattern, ref):
            zotRef = find_zotero_ref(zoteroId, items)
            if zotRef:
              if not zotRef in references:
                references.append(zotRef)
            else:
              print "%s: no zotero reference for %s, replaced with %s" % (eidId, ref, zoteroId)
            matched = True
            break
        if not matched:
          # this is a string reference
          references.append(ref)
    events.update({'_id': event['_id']}, {'$set': {'references': references}})

if __name__ == "__main__":

  gs = Client(config.google_user, config.google_password)
  db = pymongo.Connection("localhost", config.meteor_mongo_port)[config.meteor_db_name]
  db.fields.drop()
  db.events.drop()

  fields_tsv = gs.download(config.fields_spreadsheet_id, gid=0, format="tsv")
  import_fields(fields_tsv, db)

  events_gid = 0
  events_tsv = gs.download(config.events_spreadsheet_id, gid=events_gid, format="tsv")
  import_events(events_tsv, db)

  other_gids = [4, 3, 2, 6] # pathogen, host, economics, location

  for gid in other_gids:
    sheet_tsv = gs.download(config.events_spreadsheet_id, gid=gid, format="tsv")
    import_other_sheet(sheet_tsv, db)

  zot = zotero.Zotero(config.zotero_library_id, config.zotero_library_type, config.zotero_api_key)
  import_refs(db, zot)
