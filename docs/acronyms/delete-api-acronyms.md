# Delete Acronym

    DELETE api/acronyms/:id

## Description

remove an existing acronym

## Requires authentication

**Bearer Authentication is required**

## Parameters

- **id** : required (type:UUID)

## Return format

     JSON or empty body

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
curl --request DELETE \
  --url http://127.0.0.1:8080/api/acronyms/6712EFBB-CFC0-4C6D-9580-1B8E4D47C8FD \
  --header 'authorization: Bearer <JWT>'
```

**Return Body**

- No body returned for the response

**Return Code**

- **204**
