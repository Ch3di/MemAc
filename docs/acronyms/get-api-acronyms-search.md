# Search the user acronyms

    GET api/acronyms/sorted?term=:term

## Description

Searches the user acronyms using a keyword

## Requires authentication

**Bearer Authentication is required**

## Parameters

**No Parameters are required**

## Query Parameters

- **term** : required (type:String)

## Return format

     JSON

## Errors

- **UnknownError (code:500)** : this occurs when an unknown error occurred on the server side.

- **Unauthorized (code:401)** : this occurs when the provided JWT is not valid.

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
  --url http://127.0.0.1:8080/api/acronyms/sorted \
  --header 'authorization: Bearer <JWT>'
```

**Return Body**

```json
[
  {
    "short": "CS",
    "long": "Computer Science",
    "id": "AC2EA20F-47B0-490C-82C4-2249A9618A22",
    "isPrivate": false,
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
  },
  {
    "short": "NoV",
    "long": "Now Or Never",
    "id": "BC2EA20F-47B0-490C-82C4-2249A961C522",
    "isPrivate": true,
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
  }
]
```

**Return Code**

- **200**
