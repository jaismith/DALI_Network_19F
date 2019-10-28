# DALI Social Media Challenge - Backend

Uses [Flask](https://palletsprojects.com/p/flask/), [App Engine](https://cloud.google.com/appengine/), [Firestore](https://cloud.google.com/firestore/)

## Endpoints

- `/api`
  - Home, serves this page
- `/api/members`
  - Returns all members in database, with following JSON structure:
    - ```
		{
			"name": "Justin Luo",
			"picture": "https://api.typeform.com/responses/files/30e6cf1283ab1600d4a9778bd0853a7ef0ecffcd660652e875bfc45fdc214af3/IMG_0152.jpg",
			"role": "Designer",
			"year": "'20"
		},
      ...
      ```
- `/api/members/filter?field=<field>&value=<value>`
  - Returns all members matching the provided filters
	 - ```
		{ 
		"location":{ 
			 "lat":34.0522342,
			 "lng":-118.2436849
		},
			"name":"Wylie Kasai",
			"picture":"https://api.typeform.com/responses/files/6719e1b31715751ab0da01f81f569805d730cd3826495a9f5d3a117a3c8c6e48/DALI_prof.jpg",
			"role":"Designer",
			"year":"'22"
		},
		...
	    ```