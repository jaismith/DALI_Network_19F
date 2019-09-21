# location.py

import os
import requests
import firebase_admin

from firebase_admin import firestore

# environment vars
GOOGLE_CLOUD_PROJECT = os.environ.get('GOOGLE_CLOUD_PROJECT')


def get_coordinates(home):
    # get firebase instance and db ref
    firebase_admin.get_app()
    db = firestore.client()

    # get places api key
    key = db.collection('settings').document('keys').get().to_dict()['PLACES_API_KEY']
    print("getting coords for %s" % home)
    # request coordinates from places api
    response = requests.get(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json',
        params = {
            'input': home,
            'inputtype': 'textquery',
            'fields': 'geometry/location',
            'key': key,
        },
    )

    # get results
    response_json = response.json()

    # get candidates
    candidates = response_json['candidates']

    # DEBUGGING PRINT STATEMENTS BELOW, REMOVE IN PRODUCTION

    # return 404 if no candidates
    if len(candidates) == 0:
        print("oops")
        return 'no matches'
    print("got")
    return candidates[0]['geometry']['location']