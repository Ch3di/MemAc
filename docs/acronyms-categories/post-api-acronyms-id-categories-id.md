# Acronym Category Association

    POST /api/acronyms/:acronym-id/categories/:category-id

## Description

Associates an acronym to a category using their IDs

## Requires authentication

**Bearer Authentication is required**

## Parameters

- **acronym-id** : required (type:UUID)
- **category-id** : required (type:UUID)

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
  --url http://127.0.0.1:8080/api/acronyms/0EB76B15-8691-4208-B35D-9E92C4EDB451/categories/C2716394-5CF3-4DA0-8052-F810185CC2 \
  --header 'authorization: Bearer <JWT>'
```

**Return Body**

- No body returned for the response

**Return Code**

- **201**
