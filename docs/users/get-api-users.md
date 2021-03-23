# Get All Users

    GET api/users

## Description

Reads the list of all the registered users

## Requires authentication

**No Authentication is required**

## Parameters

**No Parameters are required**

## Return format

     JSON

## Errors

- **UnknownError (code:500)** : this occur when an unknown error occurred on the server side.

## Example

**Request**

```bash
curl --request GET \ --url http://127.0.0.1:8080/api/users
```

**Return Body**

```json
[
  {
    "id": "3D7BE2FE-72C3-4C1A-8A4A-78A456C733C1",
    "name": "Chady",
    "username": "ch2dy"
  }
]
```

**Return Code**

- **200**
