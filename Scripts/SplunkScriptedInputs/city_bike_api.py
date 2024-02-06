import requests

url = "http://api.citybik.es/v2/networks"

response = requests.get(url)
data = response.json()

# Write data to a file
with open("output.txt", "w") as file:
    file.write(str(data))
