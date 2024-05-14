type request = {url: string, body: option<string>}

external infer_helper: unknown => 'inferred = "%identity"
external jsonify_helper: 'json => JSON.t = "%identity"
let arraify_helper: 'object => array<(string, string)> = %raw(`(json) => Object.entries(json)`)

let from_url = (url: string) => {
  url,
  body: None,
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

let get = async (request: request) => {
  let res = await Fetch.fetch(request.url)
  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}

let post = async (request: request) => {
  let res = await Fetch.fetch(
    request.url,
    ~requestInit={
      method: Fetch.Common.POST,
      headers: {"Content-Type": "application/json"},
      body: switch request.body {
      | Some(body) => body
      | None => ""
      },
    },
  )

  switch res.ok {
  | true => {
      let json = await res.json()
      Ok(json->infer_helper)
    }
  | false => Error(res.status)
  }
}
