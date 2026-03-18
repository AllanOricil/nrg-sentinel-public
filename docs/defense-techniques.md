# NRG Sentinel — Runtime Defense Techniques

This document is the authoritative reference for every JavaScript hardening
technique used in `src/preload.js`.

Sentinel runs inside the same Node.js process as every third-party node
package it protects against. There is no sandbox boundary, no separate
process, and no OS-level isolation — everything happens in one heap. The
techniques below are the layers of defense that make meaningful enforcement
possible despite that constraint.

---

## Architecture overview

The preload is a single IIFE registered via `node -r` before Node-RED
starts. It installs all guards synchronously, before any third-party module
loads. The layering is:

```
Layer 0 — Prototype hardening
  Blocks prototype pollution before any third-party code can mutate globals.

Layer 1 — Module interception
  Module._load hook intercepts every require(), wraps dangerous modules
  with capability-checked replacements, and locks itself against removal.

Layer 2 — Node isolation
  Every node returned by getNode() is wrapped in an ES6 Proxy that
  enforces the dual-axis capability check on every property access and
  method call.

Layer 3 — Surface hardening
  Express routing methods, process.env, and the router stack are guarded
  against unauthorized manipulation after Node-RED initialises.

Layer 4 — Network policy
  Outbound HTTP/HTTPS calls are filtered against an operator-defined URL
  allowlist on top of the capability gate.

Cross-cutting — Intrinsic capture
  All built-in methods used by guard logic are pinned before Layer 0 runs.
  This is a prerequisite for every other layer, not a layer in its own right.
```

---

## 1. IIFE + strict mode

**What it does.** The entire preload is wrapped in an immediately-invoked
function expression (IIFE) with `"use strict"` at its top.

```js
(function () {
    "use strict";
    // … all guard code …
})();
```

**Why it matters.**

- Variables declared inside the IIFE are not visible to any code running
  outside it. A third-party package cannot reach Sentinel's internal
  state (captured intrinsics, `allowMap`, `_blockedEvents`, etc.) by
  inspecting the global object.
- Strict mode disables `with` statements (which can shadow identifiers
  and confuse static analysis), makes accidental global variable
  creation a TypeError, and prevents `arguments.caller` / `arguments.callee`
  from being used to walk up the call chain in ways the guard does not
  expect.
- In strict mode, `this` inside a plain function call is `undefined`
  rather than the global object, eliminating an entire class of
  unintentional global mutation.

**References.**
- [MDN: IIFE](https://developer.mozilla.org/en-US/docs/Glossary/IIFE)
- [MDN: Strict mode](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)

---

## 2. Intrinsic capture

**What it does.** Every built-in prototype method that guard logic depends
on is pinned as a standalone bound function before any `require()` call.

```js
var $strIncludes  = Function.prototype.call.bind(String.prototype.includes);
var $arrIndexOf   = Function.prototype.call.bind(Array.prototype.indexOf);
var $setHas       = Function.prototype.call.bind(Set.prototype.has);
// … and so on for every method the guards use …
```

**Why it matters.** JavaScript method dispatch is dynamic: `str.includes(x)`
looks up `includes` on `String.prototype` at call time. A malicious package
loaded after the preload could overwrite that method:

```js
// Attacker silences all Sentinel stack-frame checks:
String.prototype.includes = function () { return false; };
```

`Function.prototype.call.bind(Method)` returns a new function that holds a
direct reference to the original native implementation captured at bind time.
Any subsequent mutation of the prototype property has zero effect on the
saved alias.

Note that `Function.prototype.call` itself must not be overwritten after
capture. Because the captures are the very first statements of the IIFE —
before any `require()` — no third-party code has had a chance to run by
that point.

**Complete list of pinned intrinsics** — see the table at the end of this
section.

**Relationship to prototype hardening (technique 3).** `preventExtensions`
blocks *adding new properties* but does not prevent *overwriting existing
writable ones*. Intrinsic capture is the complementary defense: it ensures
the guard uses the original even if a property is overwritten post-capture.

**References.**
- [MDN: Function.prototype.call](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call)
- [MDN: Function.prototype.bind](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind)
- [TC39 ECMA-262 §20.2.3.3 — `Function.prototype.call`](https://tc39.es/ecma262/#sec-function.prototype.call)

### Complete pinned intrinsics reference

| Alias | Source | Used in |
|---|---|---|
| `$strIncludes` | `String.prototype.includes` | Stack frame classification in all walk helpers; `matchesNetPolicy()` |
| `$strStartsWith` | `String.prototype.startsWith` | `@node-red/` prefix filter; `local:` prefix stripping in `normalizeCallerType()` |
| `$strEndsWith` | `String.prototype.endsWith` | Captured as precaution; reserved for future path-suffix conditions |
| `$strSplit` | `String.prototype.split` | Splitting `new Error().stack` into frames; `matchesNetPolicy()` glob construction; hook-name extraction |
| `$strMatch` | `String.prototype.match` | `extractModuleFromFrame()` — running the `node_modules/(pkg)` and `/nodes/(name).js` regexes |
| `$strSubstring` | `String.prototype.substring` | `local:` prefix extraction; regex literal extraction in `matchesNetPolicy()` |
| `$strTrim` | `String.prototype.trim` | Stripping leading whitespace from raw stack frame strings |
| `$strReplace` | `String.prototype.replace` | Escaping regex-special characters in URL allowlist patterns |
| `$arrIndexOf` | `Array.prototype.indexOf` | `checkAccess()` — caller type lookup in target permission allowlists |
| `$arrSlice` | `Array.prototype.slice` | Every stack-walk helper — extracting the relevant frame window |
| `$arrForEach` | `Array.prototype.forEach` | Gate installation loops throughout the `Module._load` intercept |
| `$arrPush` | `Array.prototype.push` | `getChildProcessCallChain()` chain accumulation; SW script injection |
| `$arrJoin` | `Array.prototype.join` | `warnBlocked()` call-chain formatting; glob pattern reassembly |
| `$hasOwn` | `Object.prototype.hasOwnProperty` | API surface detection; settings-loaded detection; config-node check |
| `$freeze` | `Object.freeze` | Freezing the deep-cloned `wires` copy returned from the node proxy |
| `$preventExt` | `Object.preventExtensions` | Layer 0 prototype hardening loop |
| `$jsonParse` | `JSON.parse` | Deep-cloning the live `wires` array before freezing |
| `$jsonStringify` | `JSON.stringify` | Same deep-clone operation |
| `$Set` | `Set` constructor | `resolveCaps()` — creating the resolved capability set |
| `$setAdd` | `Set.prototype.add` | `resolveCaps()` — populating the resolved capability set |
| `$setHas` | `Set.prototype.has` | `checkAccess()` and `hasCallerCap()` — capability presence checks |
| `$reTest` | `RegExp.prototype.test` | `matchesNetPolicy()` — testing compiled URL patterns |
| `$WeakMap` | `WeakMap` constructor | Initialising `nodeConfigNodeMap` |
| `$weakMapSet` | `WeakMap.prototype.set` | `createNode` intercept — recording config-node status per instance |
| `$weakMapGet` | `WeakMap.prototype.get` | `createNodeProxy()` — reading config-node status at guard time |

---

## 3. Prototype pollution protection

**What it does.** `Object.preventExtensions()` is called on every built-in
prototype before any third-party module loads.

```js
[Object.prototype, Array.prototype, Function.prototype,
 String.prototype, Number.prototype, Boolean.prototype, RegExp.prototype]
.forEach(function (p) { Object.preventExtensions(p); });
```

**Why it matters.** Prototype pollution is a class of attack where a
malicious package injects a property directly onto `Object.prototype` (or
another shared prototype):

```js
// Classic pollution — affects every plain object in the process
Object.prototype.admin = true;
// Sentinel's permission check: obj.admin → true even without a grant
```

`preventExtensions` blocks the addition of *new* properties to a prototype.
It deliberately does not use `Object.freeze()`, which would also make existing
properties non-writable and break legitimate libraries (e.g. Express assigns
`router['BIND'] = fn` on startup, moment.js sets `proto.toString`, etc.).
The attack we are defending against is property *injection*, not property
*mutation* — `preventExtensions` is the correct surgical choice.

**Opt-out.** Set `NRG_SENTINEL_NO_PROTO_FREEZE=1` for environments where
a library legitimately needs to extend a built-in prototype at startup.

**References.**
- [MDN: Object.preventExtensions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/preventExtensions)
- [PortSwigger: Prototype Pollution](https://portswigger.net/web-security/prototype-pollution)
- [OWASP: Prototype Pollution](https://owasp.org/www-community/attacks/Prototype_pollution)
- [Snyk: Prototype Pollution in lodash](https://snyk.io/vuln/SNYK-JS-LODASH-450202) — real-world example

---

## 4. `Module._load` interception

**What it does.** Node.js routes every `require()` call through
`Module._load`. Sentinel replaces this function with its own wrapper before
any node package loads.

```js
const origLoad = Module._load;          // captured before replacement
Module._load = function sentinelLoad(request, parent, isMain) {
    // 1. Block dangerous builtins before origLoad runs
    // 2. Call origLoad to get the real module
    // 3. Wrap dangerous methods on the returned module object
    return result;
};
```

**Why it matters.** The hook fires for every `require()` anywhere in the
process — user packages, transitive dependencies, and Node-RED's own
internals. Wrapping happens at the point the module reference is first
handed to the caller, so:

- The wrapped version is what the caller stores in its local `const fs = require('fs')`.
- The original is kept in a closure inside Sentinel; no third-party code
  can reach it.
- Wrapping at load time rather than startup time means modules that are
  lazily required are still covered.

Modules guarded this way include: `fs`, `fs/promises`, `node:fs`,
`node:fs/promises`, `http`, `https`, `net`, `dgram`, `tls`,
`dns`, `dns/promises`, `child_process`, `vm`, `worker_threads`.

For `vm` and `worker_threads` the call is blocked entirely (the module
reference never reaches the caller) unless the caller holds the
corresponding capability.

**References.**
- [Node.js source: `lib/internal/modules/cjs/loader.js`](https://github.com/nodejs/node/blob/main/lib/internal/modules/cjs/loader.js)
- [Node.js docs: `require.extensions`](https://nodejs.org/api/modules.html#requireextensions) (context on the hook mechanism)

---

## 5. `Module._load` lock

**What it does.** After Sentinel installs its `Module._load` wrapper,
`Object.defineProperty` is used to make the property non-writable and
non-configurable.

```js
Object.defineProperty(Module, "_load", {
    value:        Module._load,   // the sentinel wrapper
    writable:     false,
    configurable: false,
});
```

**Why it matters.** Without this lock, a malicious package loaded early
could simply overwrite `Module._load` with the original or with its own
version, stripping all subsequent guards. Making the property non-writable
(cannot be assigned) and non-configurable (cannot be redefined via
`Object.defineProperty`) closes both bypass paths.

**References.**
- [MDN: Object.defineProperty](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty)
- [MDN: Property descriptors — configurable](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty#configurable_attribute)

---

## 6. Method wrapping with captured originals

**What it does.** When a dangerous module is loaded via `Module._load`,
its methods are replaced with guarded wrappers that:
1. Check caller identity and capability.
2. Call the **captured original** if the check passes.
3. Block (warn + return a safe fake) if it fails.

```js
var origReadFile = result.readFile;          // original captured in closure
result.readFile = function guardedReadFile() {
    var caller = getCallerModule();
    if (!hasCallerCap(caller, "fs:read")) {
        warnBlocked("fs.readFile", caller, "fs:read", chain);
        return;                              // or call callback with error
    }
    return origReadFile.apply(this, arguments);
};
```

**Why it matters.** Capturing the original immediately and storing it in a
closure means:
- No third-party code can ever call the unguarded original directly —
  the only reference to it lives inside the Sentinel closure.
- The guard cannot be stripped by deleting or overwriting the method on
  the module export object, because the wrapper is what was stored in the
  caller's local variable.
- Re-entry is safe: if a guard method calls itself internally (e.g. Sentinel
  reading a file via `fs.readFileSync` during the file watchdog), the
  `isInternalCaller()` check passes and the original is called directly.

This pattern is applied to: `fs` read/write ops, `http`/`https` request
methods, `net`/`tls` connection methods, `dgram` socket methods, `dns`
lookup methods, `child_process` exec/spawn methods, `RED.hooks.add/remove`,
Express routing methods, and the Node-RED credential, flows, registry, and
comms APIs.

---

## 7. ES6 Proxy for node isolation

**What it does.** Every node object returned by `RED.nodes.getNode()` or
yielded by `RED.nodes.eachNode()` is wrapped in an ES6 `Proxy` before being
handed to the caller.

```js
return new Proxy(realNode, {
    get:            function (target, prop) { /* capability check */ },
    set:            function (target, prop, value) { /* capability check */ },
    defineProperty: function (target, prop, descriptor) { /* capability check */ },
});
```

**Why it matters.** An ES6 `Proxy` intercepts property access at the
language level — it is not possible to bypass it from JavaScript without a
reference to the real object behind the proxy. The three traps cover:

- `get` — reading properties, calling methods.
- `set` — assigning a value directly (`node.x = y`).
- `defineProperty` — `Object.defineProperty(node, ...)`, which would bypass
  a `set` trap if the `defineProperty` trap were absent.

**Symbol handling.** The `get` trap only passes through a whitelist of known
safe symbols (`Symbol.toPrimitive`, `Symbol.toStringTag`, `Symbol.iterator`,
`Symbol.asyncIterator`, `Symbol.hasInstance`). All other symbols return
`undefined`. Without this, an attacker could call
`Object.getOwnPropertySymbols(proxy)` and read symbol-keyed internal
properties with no guard.

**Private property blocking.** Underscore-prefixed properties (`_complete`,
`_removeAllListeners`, etc.) that are not in `NODE_METHOD_CAPS` are
unconditionally blocked — no capability can ever grant access to them.

**Deep-clone + freeze for wires.** When `node.wires` is read, the proxy
returns `$freeze($jsonParse($jsonStringify(target.wires)))` — a frozen deep
copy. This prevents the caller from mutating the live wires array by
retaining a reference to it, while `freeze` prevents them from adding
properties to the copy itself.

**References.**
- [MDN: Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)
- [MDN: Proxy — defineProperty trap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/Proxy/defineProperty)
- [TC39 ECMA-262 §10.5 — Proxy Object Internal Methods](https://tc39.es/ecma262/#sec-proxy-object-internal-methods-and-internal-slots)

---

## 8. Call-stack introspection

**What it does.** Every capability check needs to know *which package* is
making the call. Sentinel reads the V8 call stack from `new Error().stack`,
parses each frame's file path against the `node_modules/<pkg>` pattern, and
identifies the first frame that belongs to a user-installed package in the
Node-RED `userDir`.

```js
var frames = $arrSlice($strSplit(new Error().stack, "\n"), 3, 20);
for (var i = 0; i < frames.length; i++) {
    if ($strIncludes(frames[i], "@node-red/")) continue;    // trusted NR core
    if ($strIncludes(frames[i], "/node_modules/express/")) continue;  // NR infra
    if ($strIncludes(frames[i], "@allanoricil/nrg-sentinel")) continue;
    var mod = extractModuleFromFrame(frames[i]);
    if (mod && isFromUserDir(frames[i])) return mod;        // first user frame
}
```

**Why it matters.** There is no other reliable in-process mechanism to
attribute a call to a specific package. Function arguments do not carry
identity, and any identity the calling package supplies could be forged.
The call stack is generated by the V8 runtime and cannot be spoofed from
JavaScript running in the same context.

**Trusted frames.** Frames from `@node-red/*`, the unscoped `node-red`
package, `express`, and Node.js internals (`node:`, `internal/`, `native`)
are skipped. An untrusted user package cannot inject itself into these
namespaces without write access to those `node_modules` directories.

**Anonymous frame handling.** V8 names the module top-level closure
`<anonymous>`, producing frames like `at Object.<anonymous> (/real/path/file.js:6:1)`.
These are *not* truly anonymous — the real file path is in the parentheses.
Truly anonymous frames from `new Function()` or `eval` have the form
`at fn (<anonymous>:1:3)`. The guard uses a regex to distinguish them and
treats them as external (untrusted), preventing an attacker from pushing
their real frame beyond the inspection window by wrapping calls in
`new Function`.

**`Error.stackTraceLimit` management.** The limit is temporarily raised to
30 around every stack walk and restored in a `finally` block. This ensures
deeply nested call chains cannot push the attacker's frame beyond the
examined range.

**`isNRCoreDirectCaller()`.** A tighter variant that checks only the
*immediately preceding* non-Sentinel frame. Used in a small number of guards
where NR core legitimately calls a guarded API (e.g. the debug node calling
`RED.comms.publish`) even while a user package is higher up the synchronous
call chain.

**References.**
- [V8: Stack Trace API](https://v8.dev/docs/stack-trace-api)
- [Node.js: `Error.stackTraceLimit`](https://nodejs.org/api/errors.html#errorstacktracelimit)

---

## 9. WeakMap for per-instance metadata

**What it does.** A `WeakMap` stores metadata about each live node instance
— specifically, whether it is a config node. This information is recorded by
the `createNode` intercept and read back by `createNodeProxy()`.

```js
var nodeConfigNodeMap = new $WeakMap();
// At createNode time:
$weakMapSet(nodeConfigNodeMap, nodeInstance, isConfigNode);
// At createNodeProxy time:
var isConfigNode = $weakMapGet(nodeConfigNodeMap, realNode) === true;
```

**Why it matters.** Storing the metadata in the `WeakMap` rather than on
the node object itself:
- Does not modify the node object, so the node's own code is unaware of
  Sentinel's bookkeeping.
- `WeakMap` keys are not enumerable — the mapping is invisible to
  `Object.keys()`, `for…in`, and `JSON.stringify()`.
- References are weak: when a node is garbage-collected the entry is
  automatically removed, preventing memory leaks over long-running
  deployments where nodes are created and destroyed repeatedly.
- `WeakMap.prototype.get` and `.set` are pinned as intrinsics
  (`$weakMapGet`, `$weakMapSet`), so a tampered `WeakMap.prototype.get`
  that returns `true` for every node cannot grant blanket config-node
  credential access.

**References.**
- [MDN: WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)

---

## 10. `configurable: false` property locks

**What it does.** After installing a guarded property accessor (setter,
getter, or data property), Sentinel calls `Object.defineProperty` with
`configurable: false` to prevent the descriptor from being replaced.

Applied to:
- `Module._load` — prevents stripping the module interception hook.
- `app._router` on Express instances — prevents an attacker from
  replacing the guarded router with an unguarded one.
- `rt.stack` on the router object — prevents the guarded stack accessor
  from being overridden.

**Why it matters.** An `Object.defineProperty` call with a new descriptor
can silently replace a previously installed getter/setter, effectively
undoing a guard. `configurable: false` makes such a call throw a
`TypeError`, closing this bypass entirely.

**References.**
- [MDN: Property descriptors — configurable](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty#configurable_attribute)

---

## 11. `_router.stack` Proxy guard

**What it does.** Express stores its middleware chain in
`app._router.stack` — a plain array. A malicious package with `http:admin`
access could still inject middleware by mutating this array in-place after
the route registration guard passes. Sentinel wraps the array in a `Proxy`
and also intercepts the `_router` property assignment via a `configurable: false`
setter.

```js
new Proxy(routerStackArray, {
    set: function (target, prop, value) {
        if (!isInternalCaller()) { warnBlocked(...); return true; }
        target[prop] = value;
        return true;
    },
    deleteProperty: function (target, prop) {
        if (!isInternalCaller()) { warnBlocked(...); return true; }
        delete target[prop];
        return true;
    },
});
```

**Why it matters.** The `set` trap intercepts:
- Direct index writes (`stack[5] = handler`)
- Length truncation (`stack.length = 0`)
- Methods that ultimately call `[[Set]]` (`push`, `splice`, `sort`,
  `reverse`, `fill`)

The `deleteProperty` trap intercepts `delete stack[i]` and
remove-only `splice` calls (which call `[[Delete]]`).

In-place mutations are the only route that bypasses the `use()`/`get()`/
etc. method wrappers, making this Proxy the necessary last layer.

**References.**
- [MDN: Proxy — set trap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/Proxy/set)
- [MDN: Proxy — deleteProperty trap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/Proxy/deleteProperty)

---

## 12. `process.env` Proxy

**What it does.** After settings are loaded (and `allowMap` is meaningful),
`process.env` is replaced with a `Proxy` that checks `process:env:read`
and `process:env:write` capabilities on every read and write.

```js
process.env = new Proxy(_origEnv, {
    get: function (target, prop) {
        if (!isInternalCaller()) {
            var caller = getCallerModule();
            if (!hasCallerCap(caller, "process:env:read")) { warnBlocked(...); return undefined; }
        }
        return target[prop];
    },
    set: function (target, prop, value) {
        if (!isInternalCaller()) {
            var caller = getCallerModule();
            if (!hasCallerCap(caller, "process:env:write")) { warnBlocked(...); return true; }
        }
        target[prop] = value;
        return true;
    },
});
```

**Why it matters.** `process` is a global object, not a module — there is
no `require('process')` call to intercept. A Proxy on `process.env` is the
only way to gate reads and writes at the language level. The guard is
installed after settings load to avoid blocking Node-RED's own boot-time
`process.env` reads, which happen before the `allowMap` is populated and
before Sentinel can meaningfully distinguish internal from external callers.

---

## 13. Fake response objects for blocked network calls

**What it does.** When an outbound HTTP/HTTPS or socket call is blocked,
Sentinel returns a fake `EventEmitter` object that looks like a real
`http.ClientRequest` or `net.Socket` to the calling code.

```js
function _sentinelFakeEmitter(err) {
    var fake = new EventEmitter();
    fake.destroyed = true;
    fake.writable  = false;
    fake.write     = function () { return false; };
    fake.end       = function () { return this; };
    // … etc …
    setImmediate(function () {
        if (fake.listenerCount("error") > 0) { fake.emit("error", err); }
    });
    return fake;
}
```

**Why it matters.** If `http.request()` simply returned `undefined` or
threw synchronously, any calling code that chains `.on('response', ...)` or
`.on('error', ...)` on the return value would throw a `TypeError` — crashing
the node, not just blocking it. The fake object:
- Has the same surface (`write`, `end`, `abort`, `destroy`, `setHeader`, …)
  so method-chaining code does not throw.
- Delivers the error via the `error` event asynchronously if the caller
  registered a listener, matching the real error-handling contract.
- Has `destroyed: true` and `writable: false` so the caller's code follows
  the "connection failed" code path rather than hanging indefinitely.

---

## 14. File integrity watchdog

**What it does.** At startup Sentinel computes a hash of its own preload
file (and `plugin.js`). A `setInterval` running every 30 seconds
re-hashes both files and compares against the startup baseline. It also
checks the file permission mode.

```js
setInterval(function () {
    // 1. Permission mode check — a write-bit appearing on a read-only file
    //    is a pre-tampering signal (attacker must chmod before editing).
    if (_shouldBeReadOnly && (fs.statSync(sentinelPath).mode & 0o222)) {
        console.error("PERMISSION CHANGE DETECTED!");
    }
    // 2. Content hash check
    if (computeFileHash(sentinelPath) !== _sentinelHash) {
        console.error("FILE TAMPERING DETECTED!");
    }
}, 30000).unref();
```

**Why it matters.** A supply-chain attacker who gains write access to the
server's filesystem (e.g. through a misconfigured volume mount or a separate
vulnerability) could edit `preload.js` directly to remove guards. The
watchdog detects:
- **Content changes** — the hash diverges from the startup snapshot.
- **Permission escalation** — a `chmod` that adds a write bit before the
  edit appears as a mode change before the hash changes, giving earlier
  warning.

The interval uses `.unref()` so the watchdog does not prevent the Node.js
process from exiting cleanly when Node-RED shuts down.

**References.**
- [Node.js: `fs.statSync`](https://nodejs.org/api/fs.html#fsstatsyncsyncpath-options)
- [MITRE ATT&CK: T1565.001 — Stored Data Manipulation](https://attack.mitre.org/techniques/T1565/001/)

---

## 15. `isInternalCaller()` trust model

**What it does.** The central predicate used by every guard to decide
whether a call originates from trusted Node-RED core code or from a
potentially malicious user package.

**Trust rules (applied in order per frame):**

| Frame contains | Decision |
|---|---|
| `@node-red/` | Trusted — skip |
| `/node_modules/node-red/lib/` or `/node_modules/node-red/red.js` | Trusted — skip |
| `@allanoricil/nrg-sentinel` | Sentinel itself — skip |
| `/node_modules/express/` | Trusted NR infrastructure — skip |
| `(node:`, `(internal/`, `(native)` | Node.js internals — trusted, skip |
| Truly anonymous (`(<anonymous>:` or `at <anonymous>:`) | **Untrusted — return false** |
| Package in userDir's `node_modules/` or `/nodes/` | **Untrusted — return false** |
| Package in a non-userDir `node_modules/` | NR's own transitive dep — skip |
| No user frame found after exhausting all frames | Trusted — return true |

**The anonymous frame rule** is the most subtle. V8 uses `<anonymous>` in
two completely different situations:

1. `at Object.<anonymous> (/real/path/file.js:6:1)` — the module top-level
   closure. Has a real file path. **Not** anonymous for our purposes.
2. `at fn (<anonymous>:1:3)` — a `new Function()` or `eval` body. No file
   path. **Truly anonymous.**

A `new Function("return RED.events.on('x',fn)")()` chain is a known
technique to push the real attacker frame beyond the inspection window while
making `isInternalCaller()` see only anonymous frames. By treating truly
anonymous frames as external, this attack is neutralised.

**References.**
- [V8: Stack Trace API — structured stack traces](https://v8.dev/docs/stack-trace-api#customizing-stack-traces)

---

## 16. Deferred `process.env` guard installation

**What it does.** The `process.env` Proxy (technique 12) is not installed
at preload startup — it is deferred until Sentinel detects that settings
have been loaded and `allowMap` is populated.

**Why it matters.** Node-RED reads many `process.env` variables during its
own boot sequence before any user package runs. If the Proxy were installed
at preload time, those reads would trigger capability checks against an
empty `allowMap`, blocking Node-RED's own initialization. Deferring until
after settings load (detected by the `Module._load` hook seeing a module
that has a `sentinel` property) means the guard becomes active only once
it can make meaningful decisions.

---

## 17. How the techniques compose

The techniques are not independent — each one closes a bypass that would
exist if only the others were active:

| Attacker action | Blocked by |
|---|---|
| Overwrite `String.prototype.includes` to blind stack checks | Intrinsic capture (§2) |
| Inject `Object.prototype.admin = true` to forge capability grants | Prototype hardening (§3) |
| Call `require('fs')` directly | Module._load interception (§4) |
| Overwrite `Module._load` to strip the hook | Module._load lock (§5) |
| Hold a pre-wrap reference to `fs.readFile` | Not possible — wrapper is installed before any user code runs |
| Call `Object.defineProperty(node, 'credentials', getter)` to steal creds | Node Proxy `defineProperty` trap (§7) |
| Read `node[Symbol.for('internal-key')]` to bypass guards | Symbol whitelist in Node Proxy (§7) |
| Wrap call in `new Function(...)()` to confuse stack walk | Anonymous frame detection in `isInternalCaller()` (§15) |
| Splice a route handler directly into `app._router.stack` | Router stack Proxy (§11) |
| Replace `app._router` with an unguarded object | `configurable: false` on `_router` (§10) |
| Edit `preload.js` on disk to remove guards | File integrity watchdog (§14) |
| Read `process.env.NODE_RED_CREDENTIAL_SECRET` | `process.env` Proxy (§12) |
| Call `vm.runInNewContext(malicious_code)` | `require('vm')` blocked at Module._load (§4) |
| Call blocked API and get a crash-inducing `null` return | Fake response objects (§13) |

---

## References

- [V8 Stack Trace API](https://v8.dev/docs/stack-trace-api)
- [MDN: Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)
- [MDN: WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)
- [MDN: Object.defineProperty](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty)
- [MDN: Object.preventExtensions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/preventExtensions)
- [MDN: Function.prototype.call](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call)
- [MDN: Strict mode](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
- [Node.js Module docs](https://nodejs.org/api/module.html)
- [PortSwigger: Prototype Pollution](https://portswigger.net/web-security/prototype-pollution)
- [TC39 ECMA-262](https://tc39.es/ecma262/)
- [MITRE ATT&CK: Supply Chain Compromise](https://attack.mitre.org/techniques/T1195/)
- [MITRE ATT&CK: Stored Data Manipulation](https://attack.mitre.org/techniques/T1565/001/)
