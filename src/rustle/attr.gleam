import gleam/dynamic.{type Dynamic}

pub type Attr(msg) {
  Attr(name: String, value: Dynamic)
  Event(
    name: String,
    handler: fn(Dynamic) -> msg,
    wrapped_handler: fn(Dynamic) -> Nil,
  )
}

fn empty_handler(_) {
  Nil
}

pub fn on_click(message: msg) -> Attr(msg) {
  Event("click", fn(_) { message }, empty_handler)
}
