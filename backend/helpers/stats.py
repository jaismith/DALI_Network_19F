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
            stats.append(Statistic(getStatName(key), "coming soon...", value))

    # return stats
    return stats

def getStatName(key):
    names = {
        "year": "Year",
        "gender": "Gender",
        "heightInches": "Height (inches)",
        "happiness": "Happiness Rating (1-5)",
        "stressed": "Stress Rating (1-10)",
        "sleepPerNight": "Sleep (hours/night)",
        "socialDinnerPerWeek": "Social Dinners (#/week)",
        "alcoholDrinksPerWeek": "Alcohol Consumption (drinks/week)",
        "caffeineRating": "Caffeine Use (1-10)",
        "affiliated": "Affiliated",
        "numOfLanguages": "Languages Spoken",
        "gymPerWeek": "Gym Use (visits/week)",
        "hoursOnScreen": "Screen Time (hours)",
        "phoneType": "Phone Type"
    }

    return names[key]