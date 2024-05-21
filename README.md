# rescript-http

A lightweight HTTP client library for ReScript, designed to be used immediately.

[한국어](./README.ko.md)

```res
open Http

type page = {
  data: array<string>,
  page: int,
  limit: int,
  total: int,
}

let url = "..."

let page: result<page, int> =
  await url
  ->from_url
  ->set_params({"page": 1, "limit": 20})
  ->get
```

## Overview

- Based on JavaScript's [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- Easily create query strings and bodies using the [Object](https://rescript-lang.org/docs/manual/latest/object) type.
- Simple to use with [Pipe (->)](https://rescript-lang.org/docs/manual/latest/pipe).

## Installation

```sh
npm install rescript-http
```

Then add `rescript-http` to `bs-dependencies` in your `bsconfig.json`.

```json
{
  "bs-dependencies": ["rescript-http"],
  "bsc-flags": ["-open RescriptHttp"] // optional
}
```

## Modules

### from_url

Takes a URL and creates a Request object.

```rescript
" ... " -> from_url
```

### set_params

Takes an object and creates query strings.

```rescript
" ... " -> from_url -> set_params({ "page": 1, "limit": 20 })
```

### add_headers

Takes an object and creates headers.

```rescript
" ... " -> from_url -> add_headers({ "Authorization": " ... " })
```

### set_body

Takes an object and creates a body.

```rescript
" ... " -> from_url -> set_body({ "name": " ... " })
```

### get

Sends a request using the Request object and returns a JSON response.

```rescript
let response:result<data,int> = await " ... " -> from_url -> get
```

### post

Sends a request using the Request object and returns a JSON response.

```rescript
let response:result<data,int> = await " ... " -> from_url -> post
```

### put

Sends a request using the Request object and returns a JSON response.

```rescript
let response:result<data,int> = await " ... " -> from_url -> put
```

### patch

Sends a request using the Request object and returns a JSON response.

```rescript
let response:result<data,int> = await " ... " -> from_url -> patch
```

### delete

Sends a request using the Request object and returns a JSON response.

```rescript
let response:result<data,int> = await " ... " -> from_url -> delete
```

### use

Allows the use of middleware.

```rescript
let logger_middleware = next => async request => {
    Console.log("request", request)
    await next(request)
}
" ... " -> from_url -> use(logger_middleware)
```
