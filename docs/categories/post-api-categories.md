# Creates new category

    POST api/categories

## Description

Creates a category

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
  "reason": "Value required for key 'name'."
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
  --url http://127.0.0.1:8080/api/categories \
  --header 'authorization: Bearer <JWT>' \
  --header 'content-type: application/json' \
  --data '{
	"name": "sports"
}'
```

**Return Body**

```json
{
  "id": "C2716394-5CF3-4DA0-8052-F81018325CC2",
  "userID": "FF959FB3-973B-456C-B86E-B37E5F657DB2",
  "name": "sports"
}
```

**Return Code**

- **200**
