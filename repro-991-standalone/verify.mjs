// Standalone repro for bartblast/hologram#991.
//
// vendor/snabbdom/ is Hologram's vendored snabbdom copy, copied verbatim from
// `dev` at the commit noted in COMMIT.txt - unmodified. No Elixir, no
// Hologram app, no unreleased feature required: this exercises the vendored
// library directly, the same way test/javascript/vendor/snabbdom_test.mjs
// does in the main repo.
import {JSDOM} from "jsdom";

const dom = new JSDOM("<!doctype html><html><body></body></html>");
global.window = dom.window;
global.document = dom.window.document;

const {attributesModule, fragment, h, init} = await import(
  "./vendor/snabbdom/build/index.js"
);

const patch = init([attributesModule], undefined, {
  experimental: {fragments: true},
});

const blockFragment = (key, children) => ({...fragment(children), key});
const marker = (key) => h("!", {key}, key);
const item = (key, label) =>
  blockFragment(key, [marker(key), h("li", {}, [label]), marker(`${key}c`)]);

const container = document.createElement("div");
document.body.appendChild(container);

// mount
const before = patch(
  container,
  h("div", {}, [item("a", "A"), item("b", "B"), item("c", "C")]),
);

// pure reorder - no items added or removed
const after = patch(
  before,
  h("div", {}, [item("a", "A"), item("c", "C"), item("b", "B")]),
);

const result = [...after.elm.querySelectorAll("li")].map(
  (li) => li.textContent,
);
const expected = ["A", "C", "B"];

console.log("expected:", expected);
console.log("actual:  ", result);

if (JSON.stringify(result) === JSON.stringify(expected)) {
  console.log("\nOK - reorder worked (bug not present in this copy)");
  process.exit(0);
} else {
  console.log(
    "\nBUG REPRODUCED - the fragment silently failed to move, DOM order unchanged",
  );
  process.exit(1);
}
