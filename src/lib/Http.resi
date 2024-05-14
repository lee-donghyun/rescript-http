let arraify_helper: 'object => array<(string, string)>

type raw_request
type middleware
type config
type request

let from_url: (string, ~timeout: option<int>=?) => request
let add_header: (request, 'object) => request
let set_params: (request, 'object) => request
let set_body: (request, 'json) => request
let use: (request, middleware) => request
let get: request => promise<result<'data, int>>
let post: request => promise<result<'data, int>>
