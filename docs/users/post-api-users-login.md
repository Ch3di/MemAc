# Log in a user

    POST api/users/login

## Description

Registers a new user

## Requires authentication

**No Authentication is required**

## Parameters

**No Parameters are required**

## Return format

     JSON

## Errors

- **Not Found (code:404)** : this occur when the provided username does not exist.

```json
{
  "reason": "Not Found",
  "error": true
}
```

- **Unauthorized (code:401)** : this occur when the provided password is wrong.

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
  --url http://127.0.0.1:8080/api/users/login \
  --header 'content-type: application/json' \
  --data '{
	"username": "ch2di",
	"password": "12345678"
}'
```

**Return Body**

```json
{
  "token": "<JWT>",
  "user": {
    "username": "ch2di",
    "name": "chady",
    "id": "FC967031-F650-4B5B-9553-F63A6D9EFA26"
  }
}
```

**Return Code**

- **200**
