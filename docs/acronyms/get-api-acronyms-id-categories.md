# Get the user associated with an acronym

    GET api/acronyms/:id/categories

## Description

Gets the categories associated with a specific acronym

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
  --url http://127.0.0.1:8080/api/acronyms/C2ACF487-2299-4D50-8C97-C6C178CC3E48/categories \
  --header 'authorization: Bearer <JWT>'
```

**Return Body**

```json
[
  {
    "name": "Sports",
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2",
    "id": "218C95D0-483E-43F6-9654-213D0B86359B"
  },
  {
    "name": "football",
    "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2",
    "id": "FBCCDE38-D43A-4448-B206-04E5A9A6A259"
  }
]
```

**Return Code**

- **200**
