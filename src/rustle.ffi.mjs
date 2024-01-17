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

export function log(item) {
    console.log(item)
}