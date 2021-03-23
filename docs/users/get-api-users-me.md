# Get the logged in user

    GET api/users/me

## Description

Returns the id and the username of a logged in user

## Requires authentication

**Bearer Authentication is required**

## Parameters

**No Parameters are required**

## Return format

     JSON

## Errors

- **UnknownError (code:500)** : this occurs when an unknown error occurred on the server side.

- **Unauthorized (code:401)** : this occurs when the provided JWT is not valid .

```json
{
  "error": true,
  "reason": "Unauthorized"
}
```

## Example

**Request**

```bash
curl --request GET \
  --url http://127.0.0.1:8080/api/users/me \
  --header 'authorization: Bearer <JWT>'
```

**Return Body**

```json
{
  "id": "60B9AC4B-757C-4A92-9DCB-987D1D5966C6",
  "username": "ch1di"
}
```

**Return Code**

- **200**
