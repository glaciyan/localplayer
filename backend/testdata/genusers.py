#!/usr/bin/env python3
"""
register_users.py

Reads users.json and signs up each user by calling the /user/signup endpoint
with their name and password. Expects client.post to return a dict.
"""

import json
from client import APIClient

def main():
    client = APIClient()

    with open('users.json', 'r') as f:
        users = json.load(f)

    for user in users:
        payload = {
            "name": user["name"],
            "password": user["password"]
        }

        client.post("/user/signup", json=payload)

if __name__ == "__main__":
    main()
