import os
import requests
from fastapi import FastAPI, Request
import uvicorn

app = FastAPI()

@app.get("/")
async def get_weather(request: Request):
    api_key = os.getenv("API_KEY", "")
    lat = request.query_params.get('lat')
    lon = request.query_params.get('lon')
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}"
    weather = requests.get(url).json()
    return weather

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)