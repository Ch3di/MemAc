# Get the user acronyms using their ID

    GET api/users/:id/acronyms

## Description

Reads the list of all the public acronyms of specific user.

## Requires authentication

**No Authentication is required**

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

## Example

**Request**

```bash
curl --request GET \
  --url http://127.0.0.1:8080/api/users/FF959FB3-973B-556C-B86E-B37E5F657DB2/acronyms
```

**Return Body**

```json
[
  {
    "short": "NoV",
    "long": "Now Or Never",
    "id": "BC2EA20F-47B0-490C-82C4-2249A961C522",
    "isPrivate": false,
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
  }
]
```

**Return Code**

- **200**
