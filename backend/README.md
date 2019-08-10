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
      ```
