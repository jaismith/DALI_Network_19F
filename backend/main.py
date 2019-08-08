#!flask/bin/python 3.7

# Imports

import logging
import os
import json
import firebase_admin
import grip

from flask import Flask, jsonify, request, Response, redirect
from firebase_admin import credentials
from firebase_admin import firestore
from grip import render_page

from models import Member, Network
from helpers import generate_network

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
@app.route('/api')
def home():
    return render_page(render_inline = True), 200

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
            if data_type == 'keyed':
                data[value['name']] = value
            else:
                data[str(index)] = value

        # write raw data to firestore
        doc = db.collection('source').document('%s' % data_type)
        doc.set(data)
        
        # log
        logging.debug("Received %s data, generating Network" % data_type)

        # if keyed, generate network
        if data_type == 'keyed':
            network = generate_network(data)

            # write network to firestore
            doc = db.collection('data').document('network')
            doc.set(network.to_dict())

            return Response(status = 201)

    elif request.method == 'GET':
        #get blob from bucket
        data = db.collection('source').document('%s' % data_type)
        
        return jsonify(data.get().to_dict()), 200

# members
@app.route('/api/members', methods = ['GET'])
@app.route('/api/members/<member>', methods = ['GET'])
def members(member = None):
    # get members from database
    members = db.collection('source').document('keyed').get().to_dict()

    # check to make sure members were successfully loaded
    if members == None:
        return Response(status = 503)

    # check if specific user was requested
    if member is not None:
        if member in members:
            return jsonify(members[member]), 200
        else:
            return Response(status = 404)

    # abbreviate member info (less info)
    member_dict = []
    for member in members.values():
        member_dict.append(Member.from_dict(member).to_dict(abbreviated = True))

    # return all users
    return jsonify(member_dict), 200

# members with tags
@app.route('/api/members/filter', methods = ['GET'])
def members_filter():
    # return error if no tag was provided
    if not all (arg in request.args for arg in ('field', 'value')):
        return jsonify('Incorrect parameters received: %s, need \'field\' and \'value\'' % request.args), 400

    # get tag
    field = request.args['field']
    value = request.args['value']

    # get network from firestore
    network = Network.from_dict(db.collection('data').document('network').get().to_dict())

    # get members matching tag
    members = network.get_members_of('(%s, %s)' % (field, value))

    # convert members to response compatible format
    # members_dict = dict()
    for member in members:
        member = member.to_dict(abbreviated = True)
        # member_dict = member.to_dict(abbreviated = True)
        # members_dict[member.name] = member_dict
    
    return jsonify(members), 200

if __name__ == '__main__':
	app.run(host = '127.0.0.1', port = 8080, debug = True)