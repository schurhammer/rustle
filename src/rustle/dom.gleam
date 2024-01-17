import gleam/dynamic

pub type Node

@external(javascript, "../rustle.ffi.mjs", "log")
pub fn log(_item: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_query_selector")
pub fn query_selector(_query: String) -> Node {
  dynamic.unsafe_coerce(dynamic.from(Nil))
}

@external(javascript, "../rustle.ffi.mjs", "dom_null_node")
pub fn null_node() -> Node {
  dynamic.unsafe_coerce(dynamic.from(Nil))
}

@external(javascript, "../rustle.ffi.mjs", "dom_create_element")
pub fn create_element(_tag: String) -> Node {
  dynamic.unsafe_coerce(dynamic.from(Nil))
}

@external(javascript, "../rustle.ffi.mjs", "dom_create_text")
pub fn create_text(_tag: String) -> Node {
  dynamic.unsafe_coerce(dynamic.from(Nil))
}

@external(javascript, "../rustle.ffi.mjs", "dom_append")
pub fn append(_parent: Node, _child: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_remove")
pub fn remove(_parent: Node, _remove: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_replace")
pub fn replace(_parent: Node, _replace: Node, _with: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_replace_content")
pub fn replace_content(_text_node: Node, _content: String) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_set_attribute")
pub fn set_attribute(_parent: Node, _key: String, _value: a) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_remove_attribute")
pub fn remove_attribute(_parent: Node, _key: String) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_add_event_listener")
pub fn add_event_listener(_parent: Node, _key: String, _value: a) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_remove_event_listener")
pub fn remove_event_listener(_parent: Node, _key: String, _value: a) -> Nil {
  Nil
}
