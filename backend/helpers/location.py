# location.py

import os
import requests
import firebase_admin

from firebase_admin import firestore

# environment vars
GOOGLE_CLOUD_PROJECT = os.environ.get('GOOGLE_CLOUD_PROJECT')


def get_home(member):
    # get firebase instance and db ref
    firebase_admin.get_app()
    db = firestore.client()

    # extract 'home' entry in member data
    if 'home' not in member:
        return 'no home'
    place = member['home']

    # get places api key
    key = db.collection('settings').document('keys').get().to_dict()['PLACES_API_KEY']
    
    # request coordinates from places api
    response = requests.get(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json',
        params = {
            'input': place,
            'inputtype': 'textquery',
            'fields': 'geometry/location',
            'key': key,
        },
    )

    # get results
    response_json = response.json()

    # get candidates
    candidates = response_json['candidates']

    # return 404 if no candidates
    if len(candidates) == 0:
        return 'no matches'

    return candidates[0]['geometry']['location']