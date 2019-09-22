# network.py

from models import Member, Network
from helpers.fun_facts import generate_fun_facts


def generate_network(data):
    # generate list of member objects
    members = dict()
    for name, value in data.items():
        members[name] = Member(value, raw = True)

    # generate network
    network = Network(members)

    return network

def process_fun_facts(network):
    # generate fun facts
    for member in network.members.values():
      member.other['fun_facts'] = generate_fun_facts(member.name, network)