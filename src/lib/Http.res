type raw_request = {url: string, body: option<string>, headers: array<(string, string)>}
type middleware = (raw_request => promise<Fetch.response>) => raw_request => promise<Fetch.response>
type config = {timeout: option<int>, middlewares: array<middleware>}
type request = {...raw_request, config: config}

external infer_helper: unknown => 'inferred = "%identity"
external jsonify_helper: 'json => JSON.t = "%identity"
let arraify_helper: 'object => array<(string, string)> = %raw(`(json) => Object.entries(json)`)

let from_url = (url: string, ~timeout: option<int>=None) => {
  url,
  body: None,
  headers: [],
  config: {
    timeout,
    middlewares: [],
  },
}

let add_header = (request: request, header: 'object) => {
  ...request,
  headers: request.headers->Array.concat(header->arraify_helper),
}

let set_params = (request: request, params: 'json) => {
  ...request,
  url: request.url
  ->String.concat("?")
  ->String.concat(
    params
    ->arraify_helper
    ->Array.map(((key, value)) => key ++ "=" ++ value)
    ->Array.join("&"),
  ),
}

let set_body = (request: request, body: 'json) => {
  ...request,
  body: Some(body->jsonify_helper->JSON.stringify),
}

let use = (request: request, middleware: middleware) => {
  ...request,
  config: {
    ...request.config,
    middlewares: request.config.middlewares->Array.concat([middleware]),
  },
}

let get = async (request: request) => {
  let combined = request.config.middlewares->Belt.Array.reduce(
    (raw_request: raw_request) =>
      Fetch.fetch(
        raw_request.url,
        ~requestInit={
          method: Fetch.Common.GET,
          headers: raw_request.headers,
        },
      ),
    (acc, middleware) => acc->middleware,
  )

  let raw_request: raw_request = {
    url: request.url,
    body: request.body,
    headers: request.headers,
  }
  let res = await combined(raw_request)

  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}

let post = async (request: request) => {
  let combined = request.config.middlewares->Belt.Array.reduce(
    (raw_request: raw_request) =>
      Fetch.fetch(
        raw_request.url,
        ~requestInit={
          method: Fetch.Common.POST,
          headers: [("Content-Type", "application/json")]->Array.concat(raw_request.headers),
          body: switch raw_request.body {
          | Some(body) => body
          | None => ""
          },
        },
      ),
    (acc, middleware) => acc->middleware,
  )

  let raw_request: raw_request = {
    url: request.url,
    body: request.body,
    headers: request.headers,
  }
  let res = await combined(raw_request)

  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}
