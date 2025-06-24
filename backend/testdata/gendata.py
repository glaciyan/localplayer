#!/usr/bin/env python3
"""
batch_update_with_client.py

1. Reads users.json
2. For each user:
   a. Uses a requests.Session to POST /user/login and grab the id cookie
   b. Injects that cookie into APIClient.headers
   c. Uses APIClient to PUT /profile/me and POST /presence/current
3. Writes out user_cookies.json with all {name, id}
"""

import json
import os
import requests
from client import APIClient

USERS_FILE = "users.json"
COOKIES_FILE = "user_cookies.json"
BASE_URL = os.getenv("API_BASE_URL", "http://localhost:3030")

def login_and_get_cookie(name: str, password: str) -> (str, requests.Session):
    sess = requests.Session()
    sess.headers.update({"not_secret": "1dfeR4HaWDbWqFHLkxsg1d"})
    login_url = f"{BASE_URL}/user/login"
    resp = sess.post(login_url, json={"name": name, "password": password}, timeout=30)
    resp.raise_for_status()
    cid = sess.cookies.get("id")
    if not cid:
        raise RuntimeError("Login succeeded but no 'id' cookie was set")
    return cid, sess

def main():
    with open(USERS_FILE, "r") as f:
        users = json.load(f)

    cookie_list = []

    for user in users:
        name = user["name"]
        pwd  = user["password"]

        # ——— LOGIN + CAPTURE COOKIE ———
        try:
            cookie_id, session = login_and_get_cookie(name, pwd)
            print(f"✅ [{name}] logged in, id={cookie_id}")
        except Exception as e:
            print(f"❌ [{name}] login error: {e}")
            continue

        # ——— PREPARE CLIENT ———
        client = APIClient(base_url=BASE_URL)
        # inject the cookie into headers for APIClient
        client.headers["Cookie"] = f"id={cookie_id}"

        # ——— UPDATE PROFILE ———
        prof_payload = {
            "displayName": user["displayName"],
            "biography":   user.get("bio", ""),
            "spotifyLink": user["spotifyLink"]
        }
        prof_resp = client.patch("/profile/me", json=prof_payload)
        if prof_resp.get("error"):
            print(f"   ❌ [{name}] profile update failed:", prof_resp["error"])
        else:
            print(f"   ✔️ [{name}] profile updated")

        # ——— SET PRESENCE ———
        pres_payload = {
            "latitude":  str(user["latitude"]),
            "longitude": str(user["longitude"]),
            "fakingRadiusMeters": "3000"
        }
        pres_resp = client.post("/presence/current", json=pres_payload)
        if pres_resp.get("error"):
            print(f"   ❌ [{name}] presence update failed:", pres_resp["error"])
        else:
            print(f"   ✔️ [{name}] presence set")

        cookie_list.append({"name": name, "id": cookie_id})

    # ——— SAVE COOKIES ———
    with open(COOKIES_FILE, "w") as f:
        json.dump(cookie_list, f, indent=2)

    print(f"\nFinished. Saved all cookies to {COOKIES_FILE}")

if __name__ == "__main__":
    main()
