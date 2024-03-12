import gleam/dynamic.{type Dynamic}
import gleam/list
import rustle/attr
import rustle/dom.{type Node}
import rustle/element as el

pub type Attr(msg) {
  Attr(name: String, value: Dynamic)
  Event(name: String, value: fn(Dynamic) -> msg, handler: fn(Dynamic) -> Nil)
}

pub type Element(msg) {
  Text(node: Node, content: String)
  Element(
    node: Node,
    tag: String,
    attrs: List(Attr(msg)),
    children: List(Element(msg)),
  )
}

pub fn patch_dom(
  root: Node,
  os: List(Element(msg)),
  ns: List(el.Element(msg)),
  send: fn(msg) -> Nil,
) {
  morph_children(root, os, ns, send, [])
}

fn build_element(new: el.Element(msg), send: fn(msg) -> Nil) -> Element(msg) {
  case new {
    el.Text(content) -> {
      let node = dom.create_text(content)
      Text(node, content)
    }
    el.Element(tag, attrs, children) -> {
      let node = dom.create_element(tag)
      let children =
        list.map(children, fn(child) { build_element(child, send) })
      let attrs = morph_attr(node, [], attrs, send)
      list.each(children, fn(child) { dom.append(node, child.node) })
      Element(node, tag, attrs, children)
    }
  }
}

fn set_attr(node: Node, n: Attr(msg)) -> Nil {
  case n {
    Attr(name, value) -> dom.set_attribute(node, name, value)
    Event(name, _, handler) -> dom.add_event_listener(node, name, handler)
  }
}

fn remove_attr(node: Node, o: Attr(msg)) -> Nil {
  case o {
    Attr(name, _) -> dom.remove_attribute(node, name)
    Event(name, _, handler) -> dom.remove_event_listener(node, name, handler)
  }
}

fn build_event_handler(n: attr.Attr(msg), send: fn(msg) -> Nil) -> Attr(msg) {
  case n {
    attr.Event(name, value) ->
      Event(name, value, fn(x) {
        let msg = value(x)
        send(msg)
      })
    attr.Attr(name, value) -> Attr(name, value)
  }
}

fn morph_attr(
  node: Node,
  os: List(Attr(msg)),
  ns: List(attr.Attr(msg)),
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
        Attr(on, ov), attr.Attr(nn, nv) if on == nn && ov == nv -> o
        Event(on, ov, _), attr.Event(nn, nv) if on == nn && ov == nv -> o
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
  old: Element(msg),
  new: el.Element(msg),
  send: fn(msg) -> Nil,
) -> Element(msg) {
  case old, new {
    Text(o_node, o_content), el.Text(n_content) ->
      case o_content == n_content {
        True -> old
        False -> {
          dom.replace_content(o_node, n_content)
          Text(o_node, n_content)
        }
      }

    Element(o_node, o_tag, o_attr, o_children),
      el.Element(n_tag, n_attr, n_children) as b ->
      case o_tag == n_tag {
        True -> {
          let children =
            morph_children(o_node, o_children, n_children, send, [])
          let attr = morph_attr(o_node, o_attr, n_attr, send)
          Element(o_node, o_tag, attr, children)
        }
        False -> {
          let b = build_element(b, send)
          dom.replace(parent, o_node, b.node)
          b
        }
      }
    Element(o_node, _, _, _), b -> {
      let b = build_element(b, send)
      dom.replace(parent, o_node, b.node)
      b
    }
    Text(o_node, _), b -> {
      let b = build_element(b, send)
      dom.replace(parent, o_node, b.node)
      b
    }
  }
}

fn morph_children(
  parent: Node,
  os: List(Element(msg)),
  ns: List(el.Element(msg)),
  send: fn(msg) -> Nil,
  acc: List(Element(msg)),
) -> List(Element(msg)) {
  case os, ns {
    [], [] -> list.reverse(acc)
    [], [n, ..ns] -> {
      let n = build_element(n, send)
      dom.append(parent, n.node)
      morph_children(parent, os, ns, send, [n, ..acc])
    }
    [o, ..os], [] -> {
      dom.remove(parent, o.node)
      morph_children(parent, os, ns, send, acc)
    }
    [o, ..os], [n, ..ns] -> {
      let n = morph_element(parent, o, n, send)
      morph_children(parent, os, ns, send, [n, ..acc])
    }
  }
}
