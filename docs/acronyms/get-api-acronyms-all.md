# Get all the public acronyms of all the users

    GET api/acronyms/all

## Description

Reads the list of all the public acronyms of all the available users.

## Requires authentication

**No Authentication is required**

## Parameters

**No Parameters are required**

## Return format

     JSON

## Errors

- **UnknownError (code:500)** : this occurs when an unknown error occurred on the server side.

## Example

**Request**

```bash
curl --request GET \
  --url http://127.0.0.1:8080/api/acronyms/all
```

**Return Body**

```json
[
  {
    "short": "NoV",
    "long": "Now Or Never",
    "id": "BC2EA20F-47B0-490C-82C4-2249A961C522",
    "isPrivate": false,
    "userID": "AA959FB3-9CCB-456C-B86E-B37E5F657DB2"
  },
  {
    "short": "CS",
    "long": "Computer Science",
    "id": "AC2EA20F-47B0-490C-82C4-2249A9618A22",
    "isPrivate": false,
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
  }
]
```

**Return Code**

- **200**
