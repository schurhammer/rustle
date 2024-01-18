import gleam/dynamic

pub type Ref(a)

@external(javascript, "../rustle.ffi.mjs", "ref_create")
pub fn create(_value: a) -> Ref(a) {
  dynamic.unsafe_coerce(dynamic.from(Nil))
}

@external(javascript, "../rustle.ffi.mjs", "ref_update")
pub fn update(_ref: Ref(a), _fn: fn(a) -> a) -> Nil {
  Nil
}
