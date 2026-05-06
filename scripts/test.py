import requests

url = "https://qversity-raw-public-data.s3.amazonaws.com/fintech_banking_dataset.json"

response = requests.get(url)

with open("banking_dataset.json", "wb") as f:
    f.write(response.content)