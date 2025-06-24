from client import APIClient


client = APIClient()

response = client.post("/user/login", json={
    "name": "bingbong",
    "password": "bingbong"
})

print(response)