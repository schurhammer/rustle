import gleam/dynamic.{type Dynamic}

pub type Attr(msg) {
  Attr(name: String, value: Dynamic)
  Event(name: String, handler: fn(Dynamic) -> msg)
}

pub fn on_click(message: msg) -> Attr(msg) {
  Event("click", fn(_) { message })
}
