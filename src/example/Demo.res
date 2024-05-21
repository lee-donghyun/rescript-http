open Http

type page = {
  data: array<string>,
  page: int,
  limit: int,
  total: int,
}

let url = "https://jsonplaceholder.typicode.com/posts/1"

let page: result<page, int> =
  await url
  ->from_url
  ->delete

switch page {
| Ok(page) => Js.log(page)
| Error(err) => Js.log(err)
}
