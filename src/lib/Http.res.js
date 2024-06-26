// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

var arraify_helper = ((json) => Object.entries(json));

function from_url(url, timeoutOpt) {
  var timeout = timeoutOpt !== undefined ? Caml_option.valFromOption(timeoutOpt) : undefined;
  return {
          url: url,
          body: undefined,
          headers: [],
          config: {
            timeout: timeout,
            middlewares: []
          }
        };
}

function add_header(request, header) {
  return {
          url: request.url,
          body: request.body,
          headers: request.headers.concat(arraify_helper(header)),
          config: request.config
        };
}

function set_params(request, params) {
  return {
          url: request.url.concat("?").concat(arraify_helper(params).map(function (param) {
                      return param[0] + "=" + param[1];
                    }).join("&")),
          body: request.body,
          headers: request.headers,
          config: request.config
        };
}

function set_body(request, body) {
  return {
          url: request.url,
          body: JSON.stringify(body),
          headers: request.headers,
          config: request.config
        };
}

function use(request, middleware) {
  var init = request.config;
  return {
          url: request.url,
          body: request.body,
          headers: request.headers,
          config: {
            timeout: init.timeout,
            middlewares: request.config.middlewares.concat([middleware])
          }
        };
}

function combine_middlewares(request, requestInit) {
  return Belt_Array.reduce(request.config.middlewares, (function (raw_request) {
                return fetch(raw_request.url, requestInit);
              }), (function (acc, middleware) {
                return middleware(acc);
              }));
}

function get_raw_request(request) {
  return {
          url: request.url,
          body: request.body,
          headers: request.headers
        };
}

async function get(request) {
  var combined = combine_middlewares(request, {
        headers: request.headers,
        method: "GET"
      });
  var res = await combined(get_raw_request(request));
  if (!res.ok) {
    return {
            TAG: "Error",
            _0: res.status
          };
  }
  var json = await res.json();
  return {
          TAG: "Ok",
          _0: json
        };
}

async function post(request) {
  var body = request.body;
  var combined = combine_middlewares(request, {
        body: body !== undefined ? body : "",
        headers: [[
              "Content-Type",
              "application/json"
            ]].concat(request.headers),
        method: "POST"
      });
  var res = await combined(get_raw_request(request));
  if (!res.ok) {
    return {
            TAG: "Error",
            _0: res.status
          };
  }
  var json = await res.json();
  return {
          TAG: "Ok",
          _0: json
        };
}

async function put(request) {
  var body = request.body;
  var combined = combine_middlewares(request, {
        body: body !== undefined ? body : "",
        headers: [[
              "Content-Type",
              "application/json"
            ]].concat(request.headers),
        method: "PUT"
      });
  var res = await combined(get_raw_request(request));
  if (!res.ok) {
    return {
            TAG: "Error",
            _0: res.status
          };
  }
  var json = await res.json();
  return {
          TAG: "Ok",
          _0: json
        };
}

async function $$delete(request) {
  var combined = combine_middlewares(request, {
        headers: request.headers,
        method: "DELETE"
      });
  var res = await combined(get_raw_request(request));
  if (!res.ok) {
    return {
            TAG: "Error",
            _0: res.status
          };
  }
  var json = await res.json();
  return {
          TAG: "Ok",
          _0: json
        };
}

async function patch(request) {
  var body = request.body;
  var combined = combine_middlewares(request, {
        body: body !== undefined ? body : "",
        headers: [[
              "Content-Type",
              "application/json"
            ]].concat(request.headers),
        method: "PATCH"
      });
  var res = await combined(get_raw_request(request));
  if (!res.ok) {
    return {
            TAG: "Error",
            _0: res.status
          };
  }
  var json = await res.json();
  return {
          TAG: "Ok",
          _0: json
        };
}

export {
  arraify_helper ,
  from_url ,
  add_header ,
  set_params ,
  set_body ,
  use ,
  get ,
  post ,
  $$delete ,
  put ,
  patch ,
}
/* No side effect */
