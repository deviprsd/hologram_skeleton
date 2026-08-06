# hologram#991 standalone repro

No Elixir, no Hologram app, no `mix`. Just the vendored snabbdom library
(copied verbatim, see `COMMIT.txt`) and a script that patches it directly.

```bash
npm install
npm run repro
```

Expected output on an unpatched copy:

```
expected: [ 'A', 'C', 'B' ]
actual:   [ 'A', 'B', 'C' ]

BUG REPRODUCED - the fragment silently failed to move, DOM order unchanged
```

(exits 0 and prints "reorder worked" if the copy in `vendor/` has the fix.)

See [bartblast/hologram#991](https://github.com/bartblast/hologram/issues/991)
for the root cause and the fix.
