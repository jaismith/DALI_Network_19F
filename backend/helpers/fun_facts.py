# fun_facts.py

from models import Network, Member
from flask import jsonify

def generate_fun_facts(member, network):
     # get groups the member is part of
    groups = network.get_member_groups(member)

    # isolate first name
    name = member.split(' ', 1)[0]

    # find small particularly small groups with at least two members (these are more notable)
    notable_groups = []
    response = ""
    special = True
    for group in groups:
        members = network.get_members_of(group)
        for individual in members:
            if individual.name == member:
                members.remove(individual)

        size = len(members)
        field = group.split(',', 1)[0].strip('() ')
        value = group.split(',', 1)[1].strip('() ')

        if 0 < size < 7:
            notable_groups.append(group)

            if len(response) == 0:
                response += ("{} ".format(name))
            else:
                if "; they also" not in response:
                    response += "; they also "
                else:
                    response += "; and "
                
            # field specific language
            response += generate_field_language(field, value, special)

            if size == 1:
                response += "{}".format(members[0].name)
            else:
                response += "{} others".format(len(members))

            special = False
                
    return jsonify(notable_groups, response), 200

def generate_field_language(field, value, special = False):
    # field specific language
    if field == 'year':
        return "{} in the same class, {}, as ".format(('are', 'is')[special], value)
    elif field == 'American Indian or Alaska Native' or field == 'Asian' or field == 'Black or African American' or field == 'Hispanic or Latino' or field == 'Middle Eastern' or field == 'Native Hawaiian or Other Pacific Islander' or field == 'White' or field == 'Other':
        return "{} of the same ethnicity, {}, as ".format(('are', 'is')[special], value)
    elif field == 'major':
        return "{} the same major, {}, as ".format(('have', 'has')[special], value)
    elif field == 'minor':
        return "{} the same minor, {}, as ".format(('have', 'has')[special], value)
    elif field == 'modification':
        return "{} modifying with the same subject, {}, as ".format(('are', 'is')[special], value)
    elif field == 'birthday':
        return "{} a birthday, {}, with ".format(('share', 'shares')[special], value)
    elif field == 'role':
        return "{} the same role, {}, as ".format(('have', 'has')[special], value)
    elif field == 'favoriteShoe':
        return "{} a favorite shoe, {}, with ".format(('share', 'shares')[special], value)
    elif field == 'favoriteArtist':
        return "{} a favorite artist, {}, with ".format(('share', 'shares')[special], value)
    elif field == 'favoriteColor':
        return "{} a favorite color, {}, with ".format(('share', 'shares')[special], value)
    elif field == 'phoneType':
        return "{} the same phone type, {}, as ".format(('have', 'has')[special], value)
    else:
        return None