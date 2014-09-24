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
		source = type(self).__name__
		return self._get_auth_token(self.email, self.password, source, service="wise")

	def download(self, spreadsheet_id, gid=0, format="csv"):
		url_format = "https://spreadsheets.google.com/feeds/download/spreadsheets/Export?key=%s&exportFormat=%s&gid=%i"
		headers = {
			"Authorization": "GoogleLogin auth=" + self.get_auth_token(),
			"GData-Version": "3.0"
		}
		req = urllib2.Request(url_format % (spreadsheet_id, format, gid), headers=headers)
		return urllib2.urlopen(req)

def import_fields(file, db):
  fields = db.fields
  tsv = csv.reader(file, delimiter='\t')
  columns = None
  for row in tsv:
    if not columns:
      columns = row
    else:
      d = dict(zip(columns, row))
      d['_id'] = str(ObjectId())
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

def import_refs(db, zotero):
  items = zotero.all_top()
  events = db.events
  for event in events.find():
    refAbstract = event.get('refAbstract')
    if refAbstract:
      if re.match('^[\d\s,]*$', refAbstract):
        references = refAbstract.split(',')
        zotRefs = []

        for reference in references:
          for item in items:
            try:
              if int(reference) == int(item['rights']):
                zotRefs.append(item)
            except Exception as e:
              print e
        if len(references) != len(zotRefs):
          print "Missing references: %s" % references
        events.update({'_id': event['_id']}, {'$set': {'references': zotRefs}})
      else:
        events.update({'_id': event['_id']}, {'$set': {'references': [refAbstract]}})

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
