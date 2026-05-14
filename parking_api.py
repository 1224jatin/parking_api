# main.py

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime
import math
import uvicorn

app = FastAPI(
    title="Parking Fare API",
    description="API to calculate parking fare based on parking hours",
    version="1.0.0"
)

# -----------------------------------
# Parking Fare Configuration
# -----------------------------------

BASE_HOUR_RATE = 20      # ₹20 per hour for first 5 hours
EXTRA_HOUR_RATE = 15     # ₹15 after 5 hours
DAILY_MAX = 300          # Maximum charge

# -----------------------------------
# Request Model
# -----------------------------------

class ParkingRequest(BaseModel):
    entry_time: str
    exit_time: str

# -----------------------------------
# Fare Calculation Logic
# -----------------------------------

def calculate_fare(total_hours: float):

    hours = math.ceil(total_hours)

    if hours <= 5:
        fare = hours * BASE_HOUR_RATE
    else:
        fare = (5 * BASE_HOUR_RATE) + ((hours - 5) * EXTRA_HOUR_RATE)

    fare = min(fare, DAILY_MAX)

    return {
        "parking_hours": hours,
        "fare": fare
    }

# -----------------------------------
# API Endpoint
# -----------------------------------

@app.post("/calculate-fare")
async def parking_fare(request: ParkingRequest):

    try:

        # Example format:
        # 2026-05-14 10:30:00

        entry = datetime.strptime(
            request.entry_time,
            "%Y-%m-%d %H:%M:%S"
        )

        exit = datetime.strptime(
            request.exit_time,
            "%Y-%m-%d %H:%M:%S"
        )

        if exit <= entry:
            raise HTTPException(
                status_code=400,
                detail="Exit time must be greater than entry time"
            )

        duration = exit - entry

        total_hours = duration.total_seconds() / 3600

        result = calculate_fare(total_hours)

        return {
            "success": True,
            "entry_time": request.entry_time,
            "exit_time": request.exit_time,
            "parking_hours": result["parking_hours"],
            "total_fare": result["fare"]
        }

    except ValueError:
        raise HTTPException(
            status_code=400,
            detail="Invalid datetime format. Use YYYY-MM-DD HH:MM:SS"
        )

# -----------------------------------
# Root Endpoint
# -----------------------------------

@app.get("/")
async def root():
    return {
        "message": "Parking Fare FastAPI Running"
    }

# -----------------------------------
# Run Server
# -----------------------------------

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
