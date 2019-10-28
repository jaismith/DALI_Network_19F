# DALI Social Media Challenge - Backend

Uses [Flask](https://palletsprojects.com/p/flask/), [App Engine](https://cloud.google.com/appengine/), [Firestore](https://cloud.google.com/firestore/), [Places API](https://developers.google.com/places/web-service/intro)

Hosted on Google App Engine [here](http://dali-network-19f.appspot.com/api).

## Endpoints

- `GET` `/api`
	- Home, serves this page
- `GET` `/api/members`
	- Returns all members in database, with following JSON structure:
		- `200`
		- ```json
			{
				"name": "Justin Luo",
				"picture": "https://api.typeform.com/responses/files/30e6cf1283ab1600d4a9778bd0853a7ef0ecffcd660652e875bfc45fdc214af3/IMG_0152.jpg",
				"role": "Designer",
				"year": "'20"
			},
			...
			```
- `GET` `/api/members/{member name}`
	- Returns a specific member from the database with all known properties.
	- `/api/members/Justin Luo`
		- `200`
		- ```json
			{ 
				"location": { 
					"lat": 43.2286174,
					"lng": -88.1103691
				},
				"name": "Justin Luo",
				"other": { 
					"American Indian or Alaska Native": "",
					"Asian": "Asian",
					"Black or African American": "",
					"Hispanic or Latino": "",
					"Middle Eastern": "",
					"Native Hawaiian or Other Pacific Islander": "",
					"Other": "",
					"White": "",
					"birthday": "7/27/98",
					"favoriteArtist": "Cage the Elephant",
					"favoriteColor": "Blue",
					"favoriteShoe": "Allbirds",
					"fun_facts": "Justin shares a favorite shoe, Allbirds, with 3 others!",
					"gender": "Male",
					"home": "Germantown, WI",
					"major": "Computer Science",
					"minor": "",
					"modification": "",
					"phoneType": "iOS",
					"quote": "\"Don't cry because it's over, smile because it happened.\" - Seuss",
					"role": "Designer",
					"year": "'20"
				},
				"picture": "https://api.typeform.com/responses/files/30e6cf1283ab1600d4a9778bd0853a7ef0ecffcd660652e875bfc45fdc214af3/IMG_0152.jpg",
				"role": "Designer",
				"year": "'20"
			}
			```
- `GET` `/api/members/filter?field=<field>&value=<value>`
	- Returns all members matching the provided filters.
	- `/api/members/filter?field="year"&value="'22"`
		- `200`  
		- ```json
			{ 
				"location": { 
					 "lat": 34.0522342,
					 "lng": -118.2436849
				},
				"name": "Wylie Kasai",
				"picture": "https://api.typeform.com/responses/files/6719e1b31715751ab0da01f81f569805d730cd3826495a9f5d3a117a3c8c6e48/DALI_prof.jpg",
				"role": "Designer",
				"year": "'22"
			},
			...
			```
- `GET` `/api/stats/filter?<filters>`
	- Returns statistics filtered by the provided properties.
	- `/api/stats/filter?phoneType=iOS`
		- `200`
		- ```json
			{ 
			  "data": { 
			     "Female": 37,
			     "Male": 18,
			     "Other": 1
			  },
			  "description": "What gender members identify as.",
			  "name": "Gender"
			},
			...
			```
- `POST` `/api/source/{data type}`
	- Rebuilds the remote database and network from the new file. Data type can be `keyed` or `unkeyed`.
	- `/api/source/keyed`
		- `201`
