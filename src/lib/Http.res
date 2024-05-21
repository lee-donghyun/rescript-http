external infer_helper: unknown => 'inferred = "%identity"
external jsonify_helper: 'json => JSON.t = "%identity"
let arraify_helper: 'object => array<(string, string)> = %raw(`(json) => Object.entries(json)`)

type raw_request = {url: string, body: option<string>, headers: array<(string, string)>}
type middleware = (raw_request => promise<Fetch.response>) => raw_request => promise<Fetch.response>
type config = {timeout: option<int>, middlewares: array<middleware>}
type request = {...raw_request, config: config}

let from_url = (url, ~timeout=None) => {
  url,
  body: None,
  headers: [],
  config: {
    timeout,
    middlewares: [],
  },
}

let add_header = (request, header) => {
  ...request,
  headers: request.headers->Array.concat(header->arraify_helper),
}

let set_params = (request, params) => {
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

let set_body = (request, body) => {
  ...request,
  body: Some(body->jsonify_helper->JSON.stringify),
}

let use = (request, middleware) => {
  ...request,
  config: {
    ...request.config,
    middlewares: request.config.middlewares->Array.concat([middleware]),
  },
}

let combine_middlewares = (request, ~requestInit) =>
  request.config.middlewares->Belt.Array.reduce(
    (raw_request: raw_request) => Fetch.fetch(raw_request.url, ~requestInit),
    (acc, middleware) => acc->middleware,
  )

let get_raw_request = request => {
  let raw_request = {
    url: request.url,
    body: request.body,
    headers: request.headers,
  }
  raw_request
}

let get = async request => {
  let combined = request->combine_middlewares(
    ~requestInit={
      method: Fetch.Common.GET,
      headers: request.headers,
    },
  )

  let res =
    await request
    ->get_raw_request
    ->combined

  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}

let post = async request => {
  let combined = request->combine_middlewares(
    ~requestInit={
      method: Fetch.Common.POST,
      headers: [("Content-Type", "application/json")]->Array.concat(request.headers),
      body: switch request.body {
      | Some(body) => body
      | None => ""
      },
    },
  )

  let res =
    await request
    ->get_raw_request
    ->combined

  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}

let put = async request => {
  let combined = request->combine_middlewares(
    ~requestInit={
      method: Fetch.Common.PUT,
      headers: [("Content-Type", "application/json")]->Array.concat(request.headers),
      body: switch request.body {
      | Some(body) => body
      | None => ""
      },
    },
  )

  let res =
    await request
    ->get_raw_request
    ->combined

  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}

let delete = async request => {
  let combined = request->combine_middlewares(
    ~requestInit={
      method: Fetch.Common.DELETE,
      headers: request.headers,
    },
  )

  let res =
    await request
    ->get_raw_request
    ->combined

  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}

let patch = async request => {
  let combined = request->combine_middlewares(
    ~requestInit={
      method: Fetch.Common.PATCH,
      headers: [("Content-Type", "application/json")]->Array.concat(request.headers),
      body: switch request.body {
      | Some(body) => body
      | None => ""
      },
    },
  )

  let res =
    await request
    ->get_raw_request
    ->combined

  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}
