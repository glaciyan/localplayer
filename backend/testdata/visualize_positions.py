import json
import folium

# Load user data
with open('users.json', 'r') as file:
    users = json.load(file)

# Compute map center as the average latitude and longitude
avg_lat = sum(u['latitude'] for u in users) / len(users)
avg_lon = sum(u['longitude'] for u in users) / len(users)

# Create a folium map
m = folium.Map(location=[avg_lat, avg_lon], zoom_start=2)

# Add a marker for each user
for u in users:
    folium.Marker(
        location=[u['latitude'], u['longitude']],
        popup=u['displayName']
    ).add_to(m)

# Save the map to an HTML file
m.save('user_map.html')
print("Map has been saved to 'user_map.html'.")