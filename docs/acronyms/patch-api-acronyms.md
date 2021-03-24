# Update Acronym

    PATCH api/acronyms/:id

## Description

Update an existing acronym

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
curl --request PATCH \
  --url http://127.0.0.1:8080/api/acronyms/5255E5B6-1463-4D20-9B15-CF8FE73D5239 \
  --header 'authorization: Bearer <JWT>' \
  --header 'content-type: application/json' \
  --data '{
	"isPrivate": true
}'
```

**Return Body**

```json
{
  "long": "Now Or Never",
  "isPrivate": true,
  "id": "D0C021D6-4047-46D8-9152-7D310FB41E0C",
  "short": "NoV",
  "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
}
```

**Return Code**

- **200**
