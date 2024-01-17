import rustle/attr.{type Attr, Attr}

pub type Node

@external(javascript, "../rustle.ffi.mjs", "dom_query_selector")
pub fn query_selector(query: String) -> Node {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "log")
pub fn log(item: a) -> Nil {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "dom_null_node")
pub fn null_node() -> Node {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "dom_create_element")
pub fn create_element(tag: String) -> Node {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "dom_create_text")
pub fn create_text(tag: String) -> Node {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "dom_append")
pub fn append(parent: Node, child: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_remove")
pub fn remove(parent: Node, remove: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_replace")
pub fn replace(parent: Node, replace: Node, with: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_replace_content")
pub fn replace_content(text_node: Node, content: String) -> Nil {
  Nil
}
