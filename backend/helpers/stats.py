# stats.py - helpful methods for generating stats

import os
import firebase_admin

from models import Statistic

# methods
def filter(db, filters):
    # get unkeyed data collection ref
    docs = db.collection('data').document('stats').collection('raw')

    # filter collection
    filtered_docs = docs
    for key, value in filters.items():
        filtered_docs = filtered_docs.where(key, '==', int(value) if value.isnumeric() else value)

    # return query results
    return filtered_docs.stream()

def generate_stats(filtered_docs, filters):
    # create set of common keys and a local dict to hold parsed doc data
    keys = None
    docs = dict()
    
    for doc in filtered_docs:
        # transfer doc data to local dict
        docs[doc.id] = doc.to_dict()

        # update keys
        if keys == None:
            keys = set(docs[doc.id].keys())
        else:
            keys = keys.intersection(docs[doc.id].keys())
    
    # create dictionary with all values for each key
    field_values = dict()
    for key in keys:
        field_values[key] = []
        for doc_id, doc_data in docs.items():
            datapoint = doc_data[key]

            if datapoint is not None:
                field_values[key].append(datapoint)
            else:
                field_values.pop(key)
                break;

    # generate dict with freq of each value
    freq_dict = dict()
    for key in field_values.keys():
        freq_dict[key] = dict()
        for value in set(field_values[key]):
            freq_dict[key][value] = field_values[key].count(value) # / len(field_values[key])

    # convert data into Statistic objects
    stats = []
    for key, value in freq_dict.items():
        if key not in filters.keys():
            stats.append(Statistic(getStatName(key), getStatDescription(key), value))

    # return stats
    return stats

def getStatName(key):
    names = {
        "year": "Year",
        "gender": "Gender",
        "heightInches": "Height",
        "happiness": "Happiness Rating",
        "stressed": "Stress Rating",
        "sleepPerNight": "Sleep",
        "socialDinnerPerWeek": "Social Dinners",
        "alcoholDrinksPerWeek": "Alcohol Consumption",
        "caffeineRating": "Caffeine Use",
        "affiliated": "Affiliated",
        "numOfLanguages": "Languages Spoken",
        "gymPerWeek": "Gym Use",
        "hoursOnScreen": "Screen Time",
        "phoneType": "Phone Type"
    }

    return names[key]

def getStatDescription(key):
    descriptions = {
        "year": "Class year of members (i.e. '20 is the class of 2020).",
        "gender": "What gender members identify as.",
        "heightInches": "How tall members are, in inches.",
        "happiness": "How members rated their happiness, on a scale of one to five.",
        "stressed": "How members rated their stress, on scale of one to ten",
        "sleepPerNight": "How many hours of sleep members get a night.",
        "socialDinnerPerWeek": "How many social dinners members attend a week.",
        "alcoholDrinksPerWeek": "How many alcoholic drinks members consume a week.",
        "caffeineRating": "How members rated their caffeine use, on a scale one one to ten.",
        "affiliated": "Whether members are affiliated (0 is unaffiliated, 1 is affiliated).",
        "numOfLanguages": "Number of languages spoken by members.",
        "gymPerWeek": "How many times members visit the gym a week.",
        "hoursOnScreen": "How many hours members spend on screens a week.",
        "phoneType": "The type of phones members use."
    }

    return descriptions[key]