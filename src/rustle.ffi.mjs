
// ref functions

export function ref_create(a) {
    return { value: a }
}

export function ref_update(ref, cb) {
    return ref.value = cb(ref.value)
}

// dom functions

export function log(node) {
    console.log(node)
}

export function dom_create_element(tag) {
    return document.createElement(tag)
}

export function dom_create_text(content) {
    return document.createTextNode(content);
}

export function dom_null_node() {
    return null
}

export function dom_query_selector(query) {
    return document.querySelector(query)
}

export function dom_append(parent, child) {
    parent.appendChild(child)
}

export function dom_remove(parent, child) {
    parent.removeChild(child)
}

export function dom_replace(parent, from, to) {
    parent.replaceChild(from, to)
}

export function dom_replace_content(node, content) {
    node.nodeValue = content;
}

export function dom_set_attribute(node, key, value) {
    node.removeAttribute(key, value);
}

export function dom_remove_attribute(node, key) {
    node.removeAttribute(key);
}

export function dom_add_event_listener(node, key, value) {
    node.addEventListener(key, value)
}

export function dom_remove_event_listener(node, key, value) {
    node.removeEventListener(key, value)
}
