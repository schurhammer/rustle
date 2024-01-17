import gleam/int
import gleam/list
import rustle
import rustle/element.{button, div, p, text}
import rustle/attr.{on_click}

pub fn main() {
  let app = rustle.App(init, update, view)
  let assert Ok(send) = rustle.start(app, "[data-app]", Nil)
  send(Inc)
  send(Inc)
  send(Inc)
  send(Dec)
  Nil
}

fn init(_) {
  #(0, rustle.None)
}

type Msg {
  Inc
  Dec
}

fn update(model, msg) {
  case msg {
    Inc -> #(model + 1, rustle.None)
    Dec -> #(model - 1, rustle.None)
  }
}

fn view(model) {
  let count = int.to_string(model)

  div([], [
    button([on_click(Dec)], [text(" - ")]),
    p([], [text(count)]),
    button([on_click(Inc)], [text(" + ")]),
    ..list.range(0, model)
    |> list.map(fn(n) { p([], [text(int.to_string(n))]) })
  ])
}
