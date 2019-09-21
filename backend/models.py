# models.py

import os

from helpers.location import get_coordinates

# models
class Member:
  def __init__(self, data, raw = False):
    self.name = data.pop('name')
    self.year = data.pop('year')
    self.picture = data.pop('picture')
    self.role = data.pop('role')

    if raw:
      self.location = get_coordinates(data['home'])
      self.other = data
    else:
      self.location = data['location']
      self.other = data['other']

  @staticmethod
  def from_dict(source):
    # get copy of source
    properties = source.copy()

    # extract instance variables
    member = Member(properties)

    return member

  def to_dict(self, abbreviated = False):
    dictionary = {}
    dictionary['name'] = self.name
    dictionary['year'] = self.year
    dictionary['picture'] = self.picture
    dictionary['role'] = self.role
    dictionary['location'] = self.location

    if not abbreviated:
      dictionary['other'] = self.other

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
      properties = member.other
      properties['year'] = member.year
      properties['role'] = member.role

      for key, value in properties.items():
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

  def get_members(self, name = None):
    if name is None:
      return self.members

    if name in self.members.keys():
      return self.members[name]

    return None

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
