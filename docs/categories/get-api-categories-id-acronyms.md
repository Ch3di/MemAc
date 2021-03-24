# Get the acronyms of a category

    GET /api/categories/:id/acronyms

## Description

Gets the acronyms associated with a specific category

## Requires authentication

**Bearer Authentication is required**

## Parameters

- **id** : required (type:UUID)

## Return format

     JSON

## Errors

- **Bad Request (code:400)** : this occur when a non v4 UUID was provided in the URI.

```json
{
  "error": true,
  "reason": "Bad ID Format"
}
```

- **Not Found (code:404)** : this occur when a non v4 UUID was provided in the URI.

```json
{
  "reason": "Not Found",
  "error": true
}
```

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
 --url http://127.0.0.1:8080/api/categories/4C908909-4898-47BE-9C92-D450D3EBEBAA/acronyms \
 --header 'authorization: Bearer <JWT>'
```

**Return Body**

```json
[
  {
    "long": "Champions League",
    "short": "CL",
    "isPrivate": false,
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2",
    "id": "0EB76B15-8691-4208-B35D-9E92C4EDB451"
  }
]
```

**Return Code**

- **200**
