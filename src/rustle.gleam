import rustle/element.{type Element}
import rustle/dom
import rustle/ref.{type Ref}

pub type App(flags, model, msg) {
  App(
    init: fn(flags) -> #(model, Cmd(msg)),
    update: fn(model, msg) -> #(model, Cmd(msg)),
    view: fn(model) -> Element(msg),
  )
}

pub type Cmd(msg) {
  None
  Cmd(message: msg)
}

fn run_command(
  app: App(flags, model, msg),
  model: model,
  command: Cmd(msg),
) -> model {
  case command {
    None -> model
    Cmd(msg) -> {
      let #(model, cmd) = app.update(model, msg)
      run_command(app, model, cmd)
    }
  }
}

type State(model, msg) {
  State(model, dom: List(Element(msg)))
}

fn tick(
  ref: Ref(State(model, msg)),
  app: App(flags, model, msg),
  cmd: Cmd(msg),
  root: dom.Node,
) {
  ref.update(ref, fn(state) {
    let State(model, dom) = state
    let model = run_command(app, model, cmd)
    let dom =
      element.update_dom(root, dom, [app.view(model)], fn(msg) {
        tick(ref, app, Cmd(msg), root)
      })
    State(model, dom)
  })
  Nil
}

pub fn start(
  app: App(flags, model, msg),
  selector: String,
  flags: flags,
) -> Result(fn(msg) -> Nil, Nil) {
  let #(model, cmd) = app.init(flags)
  let ref = ref.create(State(model, []))
  let root = dom.query_selector(selector)
  tick(ref, app, cmd, root)
  Ok(fn(msg) { tick(ref, app, Cmd(msg), root) })
}
