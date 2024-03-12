import gleam/int
import rustle.{type Cmd}
import rustle/attr.{on_click}
import rustle/element.{type Element, button, div, p, text}

pub fn main() {
  let app = rustle.App(init, update, view)
  let assert Ok(_) = rustle.start(app, "[data-app]", Nil)
  Nil
}

pub type Model =
  Int

pub type Msg {
  Inc
  Dec
}

pub fn init(_) -> #(Model, Cmd(Msg)) {
  #(0, rustle.None)
}

pub fn update(model: Model, msg: Msg) -> #(Model, Cmd(Msg)) {
  case msg {
    Inc -> #(model + 1, rustle.None)
    Dec -> #(model - 1, rustle.None)
  }
}

pub fn view(model: Model) -> Element(Msg) {
  let count = int.to_string(model)

  div([], [
    button([on_click(Dec)], [text(" - ")]),
    p([], [text(count)]),
    button([on_click(Inc)], [text(" + ")]),
  ])
}
