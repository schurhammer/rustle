import rustle/attr.{type Attr, Attr}

pub type Node

@external(javascript, "../rustle.ffi.mjs", "dom_null")
pub fn null() -> Node {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "dom_create_element")
pub fn create_element(tag: String) -> Node {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "dom_create_text_node")
pub fn create_text(tag: String) -> Node {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "dom_query_selector")
pub fn query_selector(query: String) -> Node {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "log")
pub fn log(item: a) -> Nil {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "dom_append_node")
pub fn append(parent: Node, child: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_remove_node")
pub fn remove(parent: Node, remove: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_replace_node")
pub fn replace(parent: Node, replace: Node, with: Node) -> Nil {
  Nil
}

@external(javascript, "../rustle.ffi.mjs", "dom_replace_text_content")
pub fn replace_content(text_node: Node, content: String) -> Nil {
  Nil
}
