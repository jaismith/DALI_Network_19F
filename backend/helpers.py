# helpers.py

from models import Member, Network

def generate_network(data):
    # generate list of member objects
    members = dict()
    for name, value in data.items():
        members[name] = Member(name, value)

    # generate network
    network = Network(members)

    return network