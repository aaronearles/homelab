from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import subprocess

app = FastAPI()

class Item(BaseModel):
    text: str # = None #comment/rm default value to require field
    is_done: bool = False


items = []

@app.get("/")
def root():
    return {"Hello": "World"}

@app.post("/items")
def create_item(item: Item):
    items.append(item)
    return items

@app.get("/items", response_model=list[Item])
def list_items(limit: int = 10):
    return items[0:limit]

@app.get("/items/{item_id}", response_model=Item)
def get_item(item_id: int) -> Item:
    if item_id < len(items):
        return items[item_id]
    else:
        raise HTTPException(status_code=404, detail="Item doesn't exist!")
    
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

# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run(app, host="0.0.0.0", port=8000)