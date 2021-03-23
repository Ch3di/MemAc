# Get a user using their ID

    GET api/users/:id

## Description

Reads the list of all the registered users

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
  --url http://127.0.0.1:8080/api/users/FC967031-F650-4B5B-9553-F63A6D9EFA26
```

**Return Body**

```json
{
  "name": "chady",
  "username": "ch4di",
  "id": "FC967031-F650-4B5B-9553-F63A6D9EFA26"
}
```

**Return Code**

- **200**
