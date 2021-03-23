# Registers new user account

    POST api/users

## Description

Registers a new user

## Requires authentication

**No Authentication is required**

## Parameters

**No Parameters are required**

## Return format

     JSON

## Errors

- **Bad Request (code:400)** : this occur when the passwords provided in the body request don't match or a required key was missing in the request body.

```json
{
  "error": true,
  "reason": "Passwords Did Not Match"
}
```

```json
{
  "error": true,
  "reason": "Value required for key 'confirmPassword'."
}
```

- **Conflict (code:409)** : this occur when a user tries to register an account with a taken username.

```json
{
  "error": true,
  "reason": "Username Already Taken"
}
```

## Example

**Request**

```bash
curl --request POST \
  --url 'http://127.0.0.1:8080/api/users?=' \
  --header 'content-type: application/json' \
  --data '{
	"name": "chady",
	"username": "ch2dy",
	"password": "password-example",
	"confirmPassword": "password-example"
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
