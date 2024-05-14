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
  ->Request.use(fetch => async request => {
    Console.log("before request 1")
    let response = await fetch(request)
    Console.log("after request 1")
    response
  })
  ->Request.use(fetch => async request => {
    Console.log("before request 2")
    let response = await fetch(request)
    Console.log("after request 2")
    response
  })
  ->Request.get
}

// let post_result = await post_example()
// switch post_result {
// | Ok(res: person) => Console.log2("do some with", res)
// | Error(_) => Console.error("Something went wrong")
// }

let get_result = await get_example()
switch get_result {
| Ok(res: person) => Console.log2("do some with", res)
| Error(_) => Console.error("Something went wrong")
}
