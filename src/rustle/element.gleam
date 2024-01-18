import rustle/attr.{type Attr, Attr, Event}
import gleam/string
import gleam/list
import rustle/dom.{type Node}

// TODO perhaps I should have a separate "DOM Element" type and remove the
// dom node from this type, then I don't have to use a null dom node.
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
    Event(name, _, _) -> name
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
  Element(dom.null_node(), tag, attr, children)
}

pub fn text(content: String) -> Element(msg) {
  Text(dom.null_node(), content)
}

pub fn div(attrs: List(Attr(msg)), children: List(Element(msg))) -> Element(msg) {
  element("div", attrs, children)
}

pub fn p(attrs: List(Attr(msg)), children: List(Element(msg))) -> Element(msg) {
  element("p", attrs, children)
}

pub fn button(
  attrs: List(Attr(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  element("button", attrs, children)
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

fn set_attr(node: Node, n: Attr(a)) -> Nil {
  case n {
    Attr(name, value) -> dom.set_attribute(node, name, value)
    Event(name, _, handler) -> dom.add_event_listener(node, name, handler)
  }
}

fn remove_attr(node: Node, o: Attr(a)) -> Nil {
  case o {
    Attr(name, _) -> dom.remove_attribute(node, name)
    Event(name, _, handler) -> dom.remove_event_listener(node, name, handler)
  }
}

fn build_event_handler(n: Attr(msg), send: fn(msg) -> Nil) -> Attr(msg) {
  case n {
    Event(name, value, _) ->
      Event(name, value, fn(x) {
        let msg = value(x)
        send(msg)
      })
    ns -> ns
  }
}

fn morph_attr(
  node: Node,
  os: List(Attr(msg)),
  ns: List(Attr(msg)),
  send: fn(msg) -> Nil,
) -> List(Attr(msg)) {
  case os, ns {
    [], [] -> []
    [], [n, ..ns] -> {
      let n = build_event_handler(n, send)
      set_attr(node, n)
      [n, ..morph_attr(node, os, ns, send)]
    }
    [o, ..os], [] -> {
      remove_attr(node, o)
      morph_attr(node, os, ns, send)
    }
    [o, ..os], [n, ..ns] -> {
      let n = case o, n {
        Attr(on, ov), Attr(nn, nv) if on == nn && ov == nv -> o
        Event(on, ov, _), Event(nn, nv, _) if on == nn && ov == nv -> o
        o, n -> {
          remove_attr(node, o)
          let n = build_event_handler(n, send)
          set_attr(node, n)
          n
        }
      }
      [n, ..morph_attr(node, os, ns, send)]
    }
  }
}

fn morph_element(
  parent: Node,
  old: Element(a),
  new: Element(a),
  send: fn(a) -> Nil,
) -> Element(a) {
  case old, new {
    Text(o_node, o_content), Text(_, n_content) ->
      case o_content == n_content {
        True -> old
        False -> {
          dom.replace_content(o_node, n_content)
          Text(o_node, n_content)
        }
      }

    Element(o_node, o_tag, o_attr, o_children), Element(
      _,
      n_tag,
      n_attr,
      n_children,
    ) as b ->
      case o_tag == n_tag {
        True -> {
          let children = morph_children(o_node, o_children, n_children, send)
          let attr = morph_attr(o_node, o_attr, n_attr, send)
          Element(o_node, o_tag, attr, children)
        }
        False -> {
          let b = build_element(b)
          dom.replace(parent, o_node, b.node)
          b
        }
      }
    Element(o_node, _, _, _), b -> {
      let b = build_element(b)
      dom.replace(parent, o_node, b.node)
      b
    }
    Text(o_node, _), b -> {
      let b = build_element(b)
      dom.replace(parent, o_node, b.node)
      b
    }
  }
}

fn morph_children(
  parent: Node,
  os: List(Element(a)),
  ns: List(Element(a)),
  send: fn(a) -> Nil,
) -> List(Element(a)) {
  // TODO make tail recursive
  case os, ns {
    [], [] -> []
    [], [n, ..ns] -> {
      let n = build_element(n)
      dom.append(parent, n.node)
      [n, ..morph_children(parent, os, ns, send)]
    }
    [o, ..os], [] -> {
      dom.remove(parent, o.node)
      morph_children(parent, os, ns, send)
    }
    [o, ..os], [n, ..ns] -> {
      let n = morph_element(parent, o, n, send)
      [n, ..morph_children(parent, os, ns, send)]
    }
  }
}

pub fn update_dom(
  root: Node,
  os: List(Element(a)),
  ns: List(Element(a)),
  send: fn(a) -> Nil,
) {
  morph_children(root, os, ns, send)
}
