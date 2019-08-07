# models.py

import os
import firebase_admin

from firebase_admin import credentials
from firebase_admin import firestore

# environment vars
GOOGLE_CLOUD_PROJECT = os.environ.get('GOOGLE_CLOUD_PROJECT')

# authenticate with firestore
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred, {
  'projectId': GOOGLE_CLOUD_PROJECT,
})

# get db ref
db = firestore.client()

# models
class Member:
  def __init__(self, name, year, picture, role, properties):
    self.name = name
    self.year = year
    self.picture = picture
    self.role = role
    self.properties = properties

  @staticmethod
  def from_dict(source):
    # get copy of source
    source = source.copy()

    # convert to person object
    member = Member(source.pop('name'), source.pop('year'), source.pop('picture'), source.pop('role'), source)

    return member

  def to_dict(self):
    dict = self.properties
    dict['name'] = self.name
    dict['year'] = self.year
    dict['role'] = self.role
    dict['picture'] = self.picture