# models.py

import os

from helpers.location import get_coordinates

# models
class Member:
  def __init__(self, name, properties):
    self.name = name
    self.properties = properties

    # check for home field
    if 'home' in properties:
      self.location = get_coordinates(properties['home'])
    else:
      self.location = None

  @staticmethod
  def from_dict(source):
    # get copy of source
    properties = source.copy()

    # convert to person object
    member = Member(properties.pop('name'), properties)

    return member

  def to_dict(self, abbreviated = False):
    important = ['year', 'picture', 'role']
    dictionary = {}

    # loop through all properties
    for key, value in self.properties.items():
      # if important, give own entry
      if key in important:
        dictionary[key] = value

      # otherwise, include in 'other' field if response is unabbreviated
      elif not abbreviated:
        if 'other' not in dictionary.keys():
          dictionary['other'] = {}
        
        dictionary['other'][key] = value          
    
    # add name to response
    dictionary['name'] = self.name
    dictionary['location'] = self.location

    return dictionary

class Network():
  def __init__(self, members, groups = None, group_index = None, membership_index = None):
    # all members
    self.members = members

    if not all (value is None for value in [groups, group_index, membership_index]):
      self.groups = groups
      self.group_index = group_index
      self.membership_index = membership_index

      return

    # groups of members (i.e. ("role", "Designer"): ["Justin Luo", ...]), and
    # an index of the groups (i.e. "role": ["Designer", ...])
    self.groups = dict()
    self.group_index = dict()

    # groups members are a part of (i.e. "Justin Luo": [("role", "Designer"), ...])
    self.membership_index = dict()
    
    # populate groups and index
    for member in members.values():
      for key, value in member.properties.items():
        # create property
        property = '(%s, %s)' % (key, value)

        # add individual to group corresponding to property (key, value)
        if property not in self.groups:
          self.groups[property] = [member.name]
          
          # update index
          if key not in self.group_index:
            self.group_index[key] = [value]
          else:
            self.group_index[key].append(value)
        else:
          self.groups[property].append(member.name)

        # add group to membershipIndex
        if member.name not in self.membership_index:
          self.membership_index[member.name] = [property]
        else:
          self.membership_index[member.name].append(property)

  @staticmethod
  def from_dict(source):
    return Network(members = {data['name']: Member.from_dict(data) for data in source['members'].values()},
      groups = source['groups'],
      group_index = source['group_index'],
      membership_index = source['membership_index'])
    
  def to_dict(self):
    dictionary = dict()

    dictionary['members'] = {member.name: member.to_dict() for member in self.members.values()}
    dictionary['groups'] = self.groups
    dictionary['group_index'] = self.group_index
    dictionary['membership_index'] = self.membership_index

    return dictionary

  # get all groups, option to filter by key (i.e. "role")
  def get_groups(self, key = None):
    if key is not None:
      if key in self.group_index.keys():
        return self.group_index[key]

    return self.group_index.keys()

  # get members in a group
  def get_members_of(self, group):
    if group in self.groups.keys():
      return [self.members[member] for member in self.groups[group]]

    return []

  # get groups a member is part of
  def get_member_groups(self, member_name):
    if member_name in self.membership_index.keys():
      return self.membership_index[member_name]

    return []
