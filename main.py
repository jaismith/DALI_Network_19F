#!flask/bin/python 3.7

# Imports

import logging
import os

from flask import Flask, jsonify, request, Response

from google.cloud import datastore
from google.cloud import storage

# Environment Constants

CLOUD_STORAGE_BUCKET = os.environ.get('CLOUD_STORAGE_BUCKET')


app = Flask(__name__)

@app.route('/')
def home():
    return jsonify("dali-network-19f ~ Jai Smith")

@app.route('/api/source/<type>', methods = ['GET', 'POST'])
def push(type):
    # get datastore client
    datastore_client = datastore.Client()

    # get bucket
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(CLOUD_STORAGE_BUCKET)

    if request.method == 'POST':
        file = request.files[type]

        # check for json filetype
        if os.path.splitext(file.filename)[1] != '.json':
            return jsonify("Invalid file, must have .json extension"), 400

        # create blob
        blob = bucket.blob('source/unkeyed.json')
        blob.upload_from_file(file)

        # log receipt of data
        if type == 'keyed':
            logging.debug("Received keyed data")
        elif type == 'unkeyed':
            logging.debug("Received unkeyed data")

        return Response(status = 201)

    elif request.method == 'GET':
        # get key
        key = datastore_client.key(type)

        # load entity
        entity = datastore_client.get(key)

        return jsonify({'file': entity['file']}), 200

# Setup

if __name__ == '__main__':
	app.run(host = '127.0.0.1', port = 8080, debug = True)