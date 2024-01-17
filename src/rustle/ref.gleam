pub type Ref(a)

@external(javascript, "../rustle.ffi.mjs", "ref_create")
pub fn create(_value: a) -> Ref(a) {
  todo
}

@external(javascript, "../rustle.ffi.mjs", "ref_update")
pub fn update(_ref: Ref(a), _fn: fn(a) -> a) -> a {
  todo
}
