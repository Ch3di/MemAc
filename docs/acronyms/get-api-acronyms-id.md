# Get a user using their ID

    GET api/acronyms/:id

## Description

Gets an acronym using its ID

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
  --url http://127.0.0.1:8080/api/acronyms/aa \
  --header 'authorization: Bearer <JWT>'
```

**Return Body**

```json
{
  "short": "NoV",
  "long": "Now Or Never",
  "id": "BC2EA20F-47B0-490C-82C4-2249A961C522",
  "isPrivate": false,
  "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
}
```

**Return Code**

- **200**
