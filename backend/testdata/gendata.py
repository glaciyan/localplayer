#!/usr/bin/env python3
"""
batch_update_with_client.py

1. Reads users.json
2. For each user:
   a. Uses a requests.Session to POST /user/login and grab the bearer token
   b. Injects that token into APIClient.headers as Authorization: Bearer <token>
   c. Uses APIClient to PATCH /profile/me and POST /presence/current
3. Writes out user_tokens.json with all {name, token}
"""

import json
import os
import requests
from client import APIClient

USERS_FILE = "users.json"
TOKENS_FILE = "user_tokens.json"
BASE_URL = os.getenv("API_BASE_URL", "http://localhost:3030")

NOT_SECRET_HEADER = {"not_secret": os.getenv("NOT_SECRET", "asdf")}


def login_and_get_token(name: str, password: str) -> (str, requests.Session):
    sess = requests.Session()
    sess.headers.update(NOT_SECRET_HEADER)
    login_url = f"{BASE_URL}/user/login"
    resp = sess.post(login_url, json={
                     "name": name, "password": password}, timeout=30)
    resp.raise_for_status()

    data = resp.json()
    token = data.get("token")
    if not token:
        raise RuntimeError("Login succeeded but no bearer token was returned")

    return token, sess


def main():
    with open(USERS_FILE, "r") as f:
        users = json.load(f)

    token_list = []

    for user in users:
        name = user["name"]
        pwd = user["password"]

        # ——— LOGIN + CAPTURE TOKEN ———
        try:
            bearer_token, _ = login_and_get_token(name, pwd)
            print(f"✅ [{name}] logged in, token={bearer_token}")
        except Exception as e:
            print(f"❌ [{name}] login error: {e}")
            continue

        # ——— PREPARE CLIENT ———
        client = APIClient(base_url=BASE_URL)
        client.headers["Authorization"] = f"Bearer {bearer_token}"

        # ——— UPDATE PROFILE ———
        prof_payload = {
            "displayName": user.get("displayName", ""),
            "biography":   user.get("bio", ""),
            "spotifyLink": user.get("spotifyLink", "")
        }
        prof_resp = client.patch("/profile/me", json=prof_payload)
        if prof_resp.get("error"):
            print(f"   ❌ [{name}] profile update failed: {prof_resp['error']}")
        else:
            print(f"   ✔️ [{name}] profile updated")

        # ——— SET PRESENCE ———
        pres_payload = {
            "latitude":  str(user.get("latitude", "0")),
            "longitude": str(user.get("longitude", "0")),
            "fakingRadiusMeters": "3000"
        }
        pres_resp = client.post("/presence/current", json=pres_payload)
        if pres_resp.get("error"):
            print(
                f"   ❌ [{name}] presence update failed: {pres_resp['error']}")
        else:
            print(f"   ✔️ [{name}] presence set")

        token_list.append({"name": name, "token": bearer_token})

    # ——— SAVE TOKENS ———
    with open(TOKENS_FILE, "w") as f:
        json.dump(token_list, f, indent=2)

    print(f"\nFinished. Saved all tokens to {TOKENS_FILE}")


if __name__ == "__main__":
    main()
