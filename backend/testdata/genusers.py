import client

client = client.APIClient()

client.post("/user/signup", json={
    "name": "bingbong",
    "password": "bingbong"
})

