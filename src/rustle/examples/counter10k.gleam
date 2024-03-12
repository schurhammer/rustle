import gleam/list
import rustle.{type Cmd}
import rustle/element.{type Element, div}
import rustle/examples/counter

pub fn main() {
  let app = rustle.App(init, update, view)
  let assert Ok(_) = rustle.start(app, "[data-app]", Nil)
  Nil
}

pub type Model =
  List(counter.Model)

pub type Msg {
  CounterMsg(index: Int, msg: counter.Msg)
}

pub fn init(_) -> #(Model, Cmd(Msg)) {
  #(list.repeat(counter.init(Nil).0, 5000), rustle.None)
}

pub fn update(model: Model, msg: Msg) -> #(Model, Cmd(Msg)) {
  let model =
    list.index_map(model, fn(item, index) {
      case msg.index == index {
        True -> counter.update(item, msg.msg).0
        False -> item
      }
    })
  #(model, rustle.None)
}

pub fn view(model: Model) -> Element(Msg) {
  div([], {
    use item, index <- list.index_map(model)
    counter.view(item)
    |> element.map(CounterMsg(index, _))
  })
}
