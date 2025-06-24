import requests

# host = "https://localplayer.fly.dev"
host = "http://localhost:3030"

class APIClient:
    def __init__(self, base_url = host, headers=None, timeout=30):
        self.base_url = base_url.rstrip('/')
        self.headers = headers or {}
        self.headers["secret"] = "tF_LgyuKrvOMIwVBg8WMSw"
        self.timeout = timeout

    def _request(self, method, endpoint, **kwargs):
        url = f"{self.base_url}/{endpoint.lstrip('/')}"
        try:
            response = requests.request(method, url, headers=self.headers, timeout=self.timeout, **kwargs)
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            return {"error": str(e)}

    def get(self, endpoint, params=None):
        return self._request("GET", endpoint, params=params)

    def post(self, endpoint, data=None, json=None):
        return self._request("POST", endpoint, data=data, json=json)

    def put(self, endpoint, data=None, json=None):
        return self._request("PUT", endpoint, data=data, json=json)

    def delete(self, endpoint):
        return self._request("DELETE", endpoint)
