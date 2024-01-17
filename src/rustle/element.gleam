import rustle/attr.{type Attr, Attr, Event}
import gleam/string
import gleam/list
import rustle/dom.{type Node}

// id is used for mapping the vdom element to the real dom
pub type Element(msg) {
  Text(node: Node, content: String)
  Element(
    node: Node,
    tag: String,
    attrs: List(Attr(msg)),
    children: List(Element(msg)),
  )
}

fn attr_string(attr: Attr(a)) -> String {
  case attr {
    Attr(name, value) -> name <> "=" <> string.inspect(value)
    Event(name, _) -> name
  }
}

pub fn to_string(el: Element(a)) -> String {
  case el {
    Text(_, content) -> content
    Element(_, tag, attrs, children) -> {
      let inner = string.concat(list.map(children, to_string))
      let attrs = string.join(["", ..list.map(attrs, attr_string)], " ")
      "<" <> tag <> attrs <> ">" <> inner <> "</" <> tag <> ">"
    }
  }
}

fn element(tag, attr, children) {
  Element(dom.null(), tag, attr, children)
}

pub fn text(content: String) -> Element(msg) {
  Text(dom.null(), content)
}

pub fn div(attrs: List(Attr(msg)), children: List(Element(msg))) -> Element(msg) {
  element("div", attrs, children)
}

pub fn p(attrs: List(Attr(msg)), children: List(Element(msg))) -> Element(msg) {
  element("p", attrs, children)
}

pub fn none() {
  element("$", [], [])
}

fn build_element(new: Element(a)) -> Element(a) {
  case new {
    Text(_, content) -> {
      let node = dom.create_text(content)
      Text(node, content)
    }
    Element(_, tag, attrs, children) -> {
      let node = dom.create_element(tag)
      let children = list.map(children, build_element)
      list.each(children, fn(child) { dom.append(node, child.node) })
      Element(node, tag, attrs, children)
    }
  }
}

pub fn morph(parent: Node, old: Element(a), new: Element(a)) -> Element(a) {
  case old, new {
    Text(a_node, a_content), Text(_, b_content) ->
      case a_content == b_content {
        True -> old
        False -> {
          dom.replace_content(a_node, b_content)
          Text(a_node, b_content)
        }
      }

    Element(a_node, a_tag, a_attr, a_children), Element(
      _,
      b_tag,
      b_attr,
      b_children,
    ) as b ->
      case a_tag == b_tag {
        True -> {
          let children = morph_children(a_node, a_children, b_children)
          Element(a_node, a_tag, a_attr, children)
        }
        False -> {
          let b = build_element(b)
          dom.replace(parent, a_node, b.node)
          b
        }
      }
    Element(a_node, _, _, _), b -> {
      let b = build_element(b)
      dom.replace(parent, a_node, b.node)
      b
    }
    Text(a_node, _), b -> {
      let b = build_element(b)
      dom.replace(parent, a_node, b.node)
      b
    }
  }
}

// TODO for the root node I should call morph children, so first time its an empty list and it gets appended, then its a single item list and gets replaced

pub fn morph_children(
  parent: Node,
  os: List(Element(a)),
  ns: List(Element(a)),
) -> List(Element(a)) {
  // TODO make tail recursive
  case os, ns {
    [], [] -> []
    [], [n, ..ns] -> {
      let n = build_element(n)
      dom.append(parent, n.node)
      [n, ..morph_children(parent, os, ns)]
    }
    [o, ..os], [] -> {
      dom.remove(parent, o.node)
      morph_children(parent, os, ns)
    }
    [o, ..os], [n, ..ns] -> {
      let n = morph(parent, o, n)
      [n, ..morph_children(parent, os, ns)]
    }
  }
}

pub fn button(
  attrs: List(Attr(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  element("button", attrs, children)
}
