from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import subprocess

app = FastAPI()

@app.get("/hostname")
async def get_hostname():
    """
    Get the hostname of the machine.

    Returns:
        str: The hostname.
    """
    try:
        output = subprocess.check_output(["hostname"], text=True)
        return {"hostname": output.strip()}
    except subprocess.CalledProcessError as e:
        return {"error": f"Failed to get hostname: {e}"}
