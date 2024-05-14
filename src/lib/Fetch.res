module Common = {
  type body = {
    body: string,
    bodyUsed: bool,
    blob: unit => promise<unknown>,
    formData: unit => promise<unknown>,
    json: unit => promise<unknown>,
    text: unit => promise<string>,
  }
  type headers = {"Content-Type": string}
  type method = GET | POST | PUT | DELETE | PATCH
  type responseType = [#basic | #cors | #default | #error | #opaque | #opaqueredirect]
}

type requestInit = {
  body?: string,
  headers?: Common.headers,
  method?: Common.method,
}

type rec response = {
  ...Common.body,
  headers: Common.headers,
  ok: bool,
  redirected: bool,
  status: int,
  statusText: string,
  @as("type") type_: Common.responseType,
  url: string,
  clone: unit => response,
}

@global external fetch: (string, ~requestInit: requestInit=?) => promise<response> = "fetch"
