# models.py

import firebase_admin

from firebase_admin import credentials
from firebase_admin import firestore

# authenticate with firestore
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred, {
  'projectId': project_id,
})

# get db ref
db = firestore.client()
