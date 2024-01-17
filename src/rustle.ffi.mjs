let uid_counter = 0;
export function uid() {
    return uid_counter++
}

export function ref_create(a) {
    return { value: a }
}

export function ref_update(ref, cb) {
    return ref.value = cb(ref.value)
}

export function dom_create_element(tag) {
    /** @type {HTMLElement} */
    const x = document.createElement(tag)
    return x
}

export function dom_create_text_node(content) {
    return document.createTextNode(content);
}

export function dom_null() {
    return null
}

export function dom_query_selector(query) {
    return document.querySelector(query)
}

export function dom_append_node(parent, child) {
    parent.appendChild(child)
}

export function dom_remove_node(parent, child) {
    parent.removeChild(child)
}

export function dom_replace_node(parent, from, to) {
    parent.replaceChild(from, to)
}

export function dom_replace_text_content(node, content) {
    node.nodeValue = content;
}

export function log(item) {
    console.log(item)
}