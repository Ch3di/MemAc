# Get Categories

    GET api/categories

## Description

Reads the list of all the public and private acronyms of the authenticated user.

## Requires authentication

**Bearer Authentication is required**

## Parameters

**No Parameters are required**

## Return format

     JSON

## Errors

- **UnknownError (code:500)** : this occurs when an unknown error occurred on the server side.

- **Unauthorized (code:401)** : this occurs when the provided JWT is not valid .

```json
{
  "error": true,
  "reason": "Unauthorized"
}
```

```json
{
  "reason": "exp claim verification failed: expired",
  "error": true
}
```

## Example

**Request**

```bash
curl --request GET \
  --url http://127.0.0.1:8080/api/categories \
  --header 'authorization: Bearer <JWT>'
```

**Return Body**

```json
[
  {
    "name": "football",
    "id": "31BE46F1-F8EF-4EFB-A5BE-548EC0915561",
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
  },
  {
    "name": "data science",
    "id": "C335F005-9EB0-4A5D-BE90-9DC1B70CC4FC",
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
  },
  {
    "name": "sports",
    "id": "C2716394-5CF3-4DA0-8052-F81018325CC2",
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
  }
]
```

**Return Code**

- **200**
