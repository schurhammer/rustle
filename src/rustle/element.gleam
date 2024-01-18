import rustle/attr.{type Attr, Attr, Event}
import gleam/string
import gleam/list

pub type Element(msg) {
  Text(content: String)
  Element(tag: String, attrs: List(Attr(msg)), children: List(Element(msg)))
}

fn attr_string(attr: Attr(a)) -> String {
  case attr {
    Attr(name, value) -> name <> "=" <> string.inspect(value)
    Event(name, _) -> name
  }
}

pub fn to_string(el: Element(a)) -> String {
  case el {
    Text(content) -> content
    Element(tag, attrs, children) -> {
      let inner = string.concat(list.map(children, to_string))
      let attrs = string.join(["", ..list.map(attrs, attr_string)], " ")
      "<" <> tag <> attrs <> ">" <> inner <> "</" <> tag <> ">"
    }
  }
}

fn element(tag, attr, children) {
  Element(tag, attr, children)
}

pub fn text(content: String) -> Element(msg) {
  Text(content)
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
