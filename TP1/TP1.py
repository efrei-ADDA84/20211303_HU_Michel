import os
import requests

api_key = os.getenv("API_KEY", "")
latitude = float(os.getenv("LAT", "43.3000"))
longitude = float(os.getenv("LONG", "5.4000"))

url = f"https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}"

weather = requests.get(url).json()

info_globale = weather["weather"][0]["description"]
ville = weather["name"]
temperature = weather["main"]["temp"] - 273.15

print(f"Today, at {ville}, it will be {info_globale}. The actual temperature is {temperature}°C.")
