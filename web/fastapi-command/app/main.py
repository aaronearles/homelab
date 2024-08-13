from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import subprocess

app = FastAPI()

@app.get("/date")
async def get_hostname():
    try:
        output = subprocess.check_output(["date"], text=True)
        return {"date": output.strip()}
    except subprocess.CalledProcessError as e:
        return {"error": f"Failed to get date: {e}"}
