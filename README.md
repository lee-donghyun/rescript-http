# rescript-http

rescript를 위한 경량 http 클라이언트 라이브러리. 당장 사용할 수 있도록 설계되었습니다.

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

## 개요

- javascript [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) 기반
- [Object](https://rescript-lang.org/docs/manual/latest/object) 타입을 사용하여 쿼리스트링과 바디를 쉽게 생성할 수 있습니다.
- [Pipe(->)](https://rescript-lang.org/docs/manual/latest/pipe)를 사용하여 쉽게 사용할 수 있습니다.

## 모듈

### from_url

url을 받아서 Request 객체를 생성합니다.

```rescript
" ... " -> from_url
```

### set_params

object를 받아서 쿼리스트링을 생성합니다.

```rescript
" ... " -> from_url -> set_params({ "page": 1, "limit": 20 })
```

### add_headers

object를 받아서 헤더를 생성합니다.

```rescript
" ... " -> from_url -> add_headers({ "Authorization": " ... " })
```

### set_body

object를 받아서 바디를 생성합니다.

```rescript
" ... " -> from_url -> set_body({ "name": " ... " })
```

### get

request 객체를 이용해 요청을 보내고 json 응답을 반환합니다.

```rescript
let response:result<data,int> = await " ... " -> from_url -> get
```

### post

request 객체를 이용해 요청을 보내고 json 응답을 반환합니다.

```rescript
let response:result<data,int> = await " ... " -> from_url -> post
```

### use

미들웨어를 사용할 수 있습니다.

```rescript
let logger_middleware = next => async request => {
    Console.log("request", request)
    await next(request)
}
" ... " -> from_url -> use(logger_middleware)
```
