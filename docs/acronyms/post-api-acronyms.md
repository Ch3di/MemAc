# Creates new acronym

    POST api/acronyms

## Description

Creates an acronym

## Requires authentication

**Bearer Authentication is required**

## Parameters

**No Parameters are required**

## Return format

     JSON

## Errors

- **Bad Request (code:400)** : this occur when the passwords provided in the body request don't match or a required key was missing in the request body.

```json
{
  "error": true,
  "reason": "Value required for key 'isPrivate'."
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
curl --request POST \
  --url http://127.0.0.1:8080/api/acronyms \
  --header 'authorization: Bearer <JWT>' \
  --header 'content-type: application/json' \
  --data '{
	"short": "NoV",
	"long": "Now Or Never",
	"isPrivate": false
}'
```

**Return Body**

```json
{
  "long": "Now Or Never",
  "isPrivate": false,
  "id": "D0C021D6-4047-46D8-9152-7D310FB41E0C",
  "short": "NoV",
  "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2"
}
```

**Return Code**

- **200**
