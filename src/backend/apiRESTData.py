import os
import requests
from flask import Flask, jsonify, request
from flask_restful import Api, Resource

apiRESTData = Flask(__name__)
api = Api(apiRESTData)

YELP_API_KEY = os.environ.get('YELP_API_KEY')
YELP_API_URL = "https://api.yelp.com/v3/businesses/search"

class Restaurants(Resource):
    def get(self, location = "Amherst, Masssachusetts"):
        term = request.args.get('term', 'restaurants')
        headers = {
            "Authorization": f"Bearer {YELP_API_KEY}"
        }
        params = {
            "location": location,
            "term": term,
            "limit": 10
        }

        response = requests.get( YELP_API_URL, headers=headers, params=params )

        if response.status_code != 200:
            return {"error": "Failed to fetch data from Yelp API"}, response.status_code

            # Extract relevant information
        businesses = response.json().get('businesses', [])
        results = []
        id_real = 100
        for business in businesses:
          result = {
              "id": id_real, 
              # fake data entries 100
              "address": business.get("location", {}).get("address1", "No address available"),
              "title": business.get("name", "Unknown"),
              "location": location,
              "category": "restaurant",
              "description": business.get("rating"),
              "source_link": business.get("YELP_API_URL", "No source link available")
          }
          results.append(result)
          id_real += 1

        return results
      

api.add_resource(Restaurants, '/')

if __name__ == '__main__':
    apiRESTData.run(debug=True, host='0.0.0.0', port=8080)
