module Request = Http

type person = {
  name: string,
  major: string,
}

let post_example = () => {
  "https://jsonplaceholder.typicode.com/posts"
  ->Request.from_url
  ->Request.add_header({"Authorization": "Bearer {token}"})
  ->Request.set_body({"name": 12312.1, "major": "CS"})
  ->Request.post
}

let get_example = () => {
  "https://jsonplaceholder.typicode.com/posts/1"
  ->Request.from_url
  ->Request.set_params({"page": 2, "limit": 50})
  ->Request.use(next => async request => {
    Console.log2("request header", request.headers)
    let res = await next(request)
    Console.log2("after request 1", res.headers->Array.at(1))
    res
  })
  ->Request.get
}

let get_result = await get_example()
switch get_result {
| Ok(res: person) => Console.log2("do some with", res)
| Error(_) => Console.error("Something went wrong")
}

// let post_result = await post_example()
// switch post_result {
// | Ok(res: person) => Console.log2("do some with", res)
// | Error(_) => Console.error("Something went wrong")
// }

module ApiExample = {
  let make_request = url =>
    url
    ->Request.from_url
    ->Request.add_header({"Authorization": "Bearer {token}"})
    ->Request.use(next => async request => {
      Console.log2("request url", request.url)
      await next(request)
    })

  let naver_page =
    await "https://www.naver.com"
    ->make_request
    ->Request.get
  Console.log(naver_page)
}
