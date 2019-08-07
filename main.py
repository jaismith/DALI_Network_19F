#!flask/bin/python 3.7

# Imports

import logging
import os
import json
import firebase_admin

from flask import Flask, jsonify, request, Response
from firebase_admin import credentials
from firebase_admin import firestore

# environment vars
GOOGLE_CLOUD_PROJECT = os.environ.get('GOOGLE_CLOUD_PROJECT')

app = Flask(__name__)


# authenticate with firestore
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred, {
  'projectId': GOOGLE_CLOUD_PROJECT,
})

# get db ref
db = firestore.client()

# endpoints

# home
@app.route('/')
def home():
    return jsonify("dali-network-19f ~ Jai Smith")

# datasource
@app.route('/api/source/<data_type>', methods = ['GET', 'POST'])
def push(data_type):
    # # get bucket
    # storage_client = storage.Client()
    # bucket = storage_client.get_bucket(CLOUD_STORAGE_BUCKET)

    if request.method == 'POST':
        # return error if missing data file
        if 'data' in request.files:
            file = request.files['data']
        else:
            return Response(status = 400)

        # check for json filetype
        if os.path.splitext(file.filename)[1] != '.json':
            return jsonify("Invalid file, must have .json extension"), 400

        # load json
        json_list = json.load(file)

        # if unkeyed, convert data to dict (enumerate)
        data = dict()
        for index, value in enumerate(json_list):
            if 'name' in data:
                data[value['name']] = value
            else:
                data[str(index)] = value

        # write raw data to firestore
        doc = db.collection('source').document('%s' % data_type)
        doc.set(data)
        
        # log
        logging.debug("Received %s data" % data_type)

        return Response(status = 201)

    elif request.method == 'GET':
        #get blob from bucket
        data = db.collection('source').document('%s' % data_type)
        
        return jsonify(data.get().to_dict()), 200

# members
@app.route('/api/members', methods = ['GET'])
def members():
    # get members from database
    members = db.collection('source').document('keyed').get().to_dict()

    # check to make sure members were successfully loaded
    if members == None:
        return Response(status = 503)

    # check if specific user was requested
    if 'member' in request.args:
        if request.args.get('member') in members:
            return jsonify(members[request.args.get('member')]), 200
        else:
            return Response(status = 404)

    # return all users
    return jsonify(members), 200


if __name__ == '__main__':
	app.run(host = '127.0.0.1', port = 8080, debug = True)