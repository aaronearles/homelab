# FastAPI Tutorial
#### https://www.youtube.com/watch?v=iWS9ogMPOI0
#### https://github.com/pixegami/simple-fastapi-example

### Install and Get Started
 - python -m pip install --upgrade pip
 - pip install fastapi
 - pip install uvicorn # Server that we use to test and run our fastapi apps
 - create new directory `.` and new file `main.py`
 - *See `main.py`*
 - cd `.\web\fastapi-tutorial`
 - uvicorn main:app --reload and test in browser `http://localhost:8000` : successfully returns `{"Hello": "World"}`

 ### GET and POST Routes
 
 - "Routes" are URI path endpoints. Used to define the different URL's that your app should respond to. Create routes to handle different interactions.
 
 - Start by creating a list of items `items = []`

 - `def` to define a function

 - Next create new endpoint called `create_item` that accepts `item` as an input. Users can access by sending an HTTP POST request to this path `/items`
 - `curl -X POST -H "Content-Type: application/json" 'http://localhost:8000/items?item=apple'`

 - Create another new endpoint using the GET decorator again. Path for this endpoint is going to be `/items/{item_id}` (This is a way to say that if we go to a path like `/items/1` or `/2` then we can use that variable to query the items list)

- Reminder: When saving changes, uvicorn --reload is reloading the empty list of items, they need to be added again for testing.

```
curl -X GET -H "Content-Type: application/json" 'http://localhost:8000/items'              
{"detail":"Method Not Allowed"}
curl -X POST -H "Content-Type: application/json" 'http://localhost:8000/items?item=coffee'
["coffee"]
curl -X POST -H "Content-Type: application/json" 'http://localhost:8000/items?item=bacon'
["coffee","bacon"]
curl -X GET -H "Content-Type: application/json" 'http://localhost:8000/items'
{"detail":"Method Not Allowed"}
curl -X GET -H "Content-Type: application/json" 'http://localhost:8000/items/0'
"coffee"
curl -X GET -H "Content-Type: application/json" 'http://localhost:8000/items/1'
"bacon"
curl -X GET -H "Content-Type: application/json" 'http://localhost:8000/items/2'
Internal Server Error
```

### Handling HTTP Errors

- Add better error handling with if/else and return 404 if !exist:
```
    if item_id < len(items):
        return items[item_id]
    else:
        raise HTTPException(status_code=404, detail="Item doesn't exist!")
```

```
curl -X GET -H "Content-Type: application/json" 'http://localhost:8000/items/2'
{"detail":"Item doesn't exist!"}
```

### JSON Request and Path Parameters

- list_items, default limit 10, `'http://localhost:8000/items?limit=3'` returns only 3

- Import BaseModel from pydantic and define a `class Item(BaseModel)` as a json structured object. Update `create_item` and `get_item` to use Item class instead of `str`

```
curl -X POST -H "Content-Type: application/json" 'http://localhost:8000/items?item=coffee'
{"detail":[{"type":"missing","loc":["body"],"msg":"Field required","input":null}]}
curl -X POST -H "Content-Type: application/json" -d '{"text":"coffee"}' 'http://localhost:8000/items'
[{"text":"coffee","is_done":false}]
```

- In the class, comment/remove default value `= None` to require the user to include in their request. Before & After:

```
curl -X POST -H "Content-Type: application/json" -d '{"title":"coffee"}' 'http://localhost:8000/items'
[{"text":"coffee","is_done":false},{"text":null,"is_done":false}]
curl -X POST -H "Content-Type: application/json" -d '{"title":"coffee"}' 'http://localhost:8000/items'
{"detail":[{"type":"missing","loc":["body","text"],"msg":"Field required","input":{"title":"coffee"}}]}
curl -X POST -H "Content-Type: application/json" -d '{"text":"coffee"}' 'http://localhost:8000/items'
[{"text":"coffee","is_done":false}]
```

### Response Model

- Use same basemodel class as before, add `, response_model=Item` to `@app.get("/items/{item_id}")` route, and `, response_model=list[Item]` to `@app.get("/items")` route.

- Another way to tell server/interfaces that response should conform to this model. Useful for building frontend w/ React or NextJs to interface with this API, now we have defined response structure to rely on.

### Interactive Documentation
http://localhost:8000/docs#


### From AI
@app.get("/hostname")
```
curl -X GET -H "Content-Type: application/json" 'http://localhost:8000/hostname'
{"hostname":"LAP121-105863"}
curl -X GET -H "Content-Type: application/json" 'http://localhost:8000/hostname' | jq -r .hostname
LAP121-105863
```