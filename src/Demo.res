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
