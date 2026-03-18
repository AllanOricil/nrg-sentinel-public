# NRG Sentinel — Capability System Design

---

## Principles

- **Grants are package-level, not node-level.** Capabilities are granted to an
  npm package as a whole (`callerGrants: { "my-package": [...] }`). Every node
  type, module, and callback inside that package operates under those grants.
  The system is not "node A talking to node B" — it is "package authorised to
  access resource R".

- **Entity:sub-resource:operation** — every capability follows this naming scheme.
  `node:credentials:read`, `fs:write`, `events:listen:flows:started`.

- **Default deny** — a package that has not been granted a capability cannot
  perform the operation. Sentinel blocks and logs the attempt.

- **Own-node exemption** — a node is always allowed to operate on itself (its own
  context, its own send, its own status, etc.). Capabilities only gate
  cross-package access.

- **Dual-axis check for `node:*`** — `node:*` capabilities are the only ones
  checked from two sides simultaneously:
  - **Caller side** — does the calling package have the capability in its grants?
  - **Target side** — does the target node type allow this operation on its
    instances (`targetPermissions`)?
  Both must pass. All other capability groups (`fs:*`, `network:*`, etc.) only
  have the caller side.

- **Shorthands expand one level** — `node:credentials` expands to the three
  granular credentials caps; `node:all` expands to all `node:*` caps. The
  resolver is single-level so nested shorthands must be listed explicitly in
  parent expansions.

---

## Capability Reference

### `node:*` — what a package can do to node objects in the runtime

Enforced when any code in the package calls `RED.nodes.getNode(id)` and
operates on the returned proxy. All caps below gate cross-package access only.
A node acting on `this` is always allowed.

This is the only group with a dual-axis check: the calling package must have
the capability granted, AND the target node type must permit the operation in
its `targetPermissions` entry.

> **Known leak — node existence via `getNode(id)`.** Any package can call
> `RED.nodes.getNode(id)` and check if the return value is truthy to discover
> whether a specific node ID exists, without holding any capability. The proxy
> is returned (or `null`) before any capability check fires. This is a minor
> information leak that cannot be closed without gating `getNode()` itself —
> which would break nearly all legitimate inter-node communication patterns.

| Capability | What it gates |
|---|---|
| `node:read` | Read any public property (`id`, `type`, `name`, `z`, custom fields) **and** call any public method not covered by a more specific cap. Acts as the catch-all: every part of a node's public interface that is not explicitly gated by `node:wires:read`, `node:credentials:read`, `node:context:*`, `node:send`, `node:status`, `node:log`, `node:close`, `node:receive`, or `node:events:*` requires this cap. Without it the node is fully opaque. |
| `node:write` | Set arbitrary properties on the node object via assignment (`node.prop = value`) |
| `node:send` | Call `thatNode.send(msg)` — injects a message into the flow attributed to that node (message spoofing) |
| `node:status` | Call `thatNode.status({...})` — changes the node's visual badge in the editor |
| `node:log` | Call `thatNode.log()`, `thatNode.warn()`, `thatNode.error()` — forges log entries attributed to another node |
| `node:close` | Call `close()` to shut down the node |
| `node:receive` | Call `receive(msg)` or `emit('input', msg)` to inject a message directly into the node's input handler |
| `node:events:on` | Call `on(event, fn)` on the node — registers a persistent listener (e.g. spy on all input messages) |
| `node:events:remove-listeners` | Call `removeAllListeners()` / `removeListener()` on the node's EventEmitter |
| `node:list` | `RED.nodes.eachNode()` — iterate over all nodes in the runtime |
| `node:wires:read` | Read `node.wires` — the output wire topology |
| `node:wires:write` | Call `updateWires(wires)` — rewire the node's outputs |
| `node:credentials:read` | Read `node.credentials` / `getCredentials(id)` |
| `node:credentials:write` | Write `node.credentials` / `addCredentials(id, creds)` |
| `node:credentials:delete` | `deleteCredentials(id)` |
| `node:context:read` | Call `thatNode.context().get(key)` / `thatNode.context().keys()` via a `getNode()` reference |
| `node:context:write` | Call `thatNode.context().set(key, value)` via a `getNode()` reference |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `node:events` | `node:events:on` + `node:events:remove-listeners` |
| `node:wires` | `node:wires:read` + `node:wires:write` |
| `node:credentials` | `node:credentials:read` + `node:credentials:write` + `node:credentials:delete` |
| `node:context` | `node:context:read` + `node:context:write` |
| `node:all` | All `node:*` capabilities above |

> **Implementation gap — `Object.defineProperty()` bypasses `node:write`.**
> The proxy `set` trap captures `thatNode.prop = value` but
> `Object.defineProperty(thatNode, 'key', descriptor)` hits the
> `defineProperty` trap, not `set`. If the proxy has no `defineProperty` trap,
> `node:write` is bypassable. The proxy implementation must add a
> `defineProperty` trap that enforces the same `node:write` check.

---

### `flows:*` — what a package can do to the deployed flow graph

Gates access to `RED.runtime.flows.*`.

| Capability | What it gates |
|---|---|
| `flows:read` | `getFlows()`, `getFlow(id)` |
| `flows:write` | `addFlow(flow)`, `updateFlow(id, flow)`, `setFlows(config)` |
| `flows:delete` | `removeFlow(id)` |
| `flows:start` | `startFlows()` — start the entire flow runtime |
| `flows:stop` | `stopFlows()` — stop the entire flow runtime (denial-of-service vector) |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `flows:all` | `flows:read` + `flows:write` + `flows:delete` + `flows:start` + `flows:stop` |

> `setFlows()` is grouped under `:write` (not a separate `:replace`) because it
> is semantically a write — it replaces the running config with a new one. Its
> destructive potential is covered by requiring an explicit `flows:write` grant.

---

### `storage:*` — what a package can do to the persistent storage layer

Gates access to `RED.runtime.storage.*` — the raw persistence API that reads
and writes flows, credentials, and settings directly to disk. This is a
distinct layer below `flows:*`: `flows:*` goes through the runtime (validation,
hooks, events); `storage:*` bypasses all of that and touches the files directly.

| Capability | What it gates |
|---|---|
| `storage:read` | `getFlows()`, `getCredentials()`, `getSettings()`, `getLibraryEntry()` |
| `storage:write` | `saveFlows()`, `saveCredentials()`, `saveSettings()`, `saveLibraryEntry()` |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `storage:all` | `storage:read` + `storage:write` |

> **Threat without this gate:** a package accessing `RED.runtime.storage`
> directly can read the raw encrypted credentials file, overwrite flows on disk
> without triggering any runtime hooks or events, and bypass the entire
> `flows:*` capability layer. It also bypasses `fs:*` because it goes through
> the storage adapter object rather than `require('fs')`.
>
> **Implementation note.** `RED.runtime.storage` is not part of the standard
> `RED` object exposed to node packages via `createNodeApi`. The threat path is
> a package requiring the storage module directly:
> `require('@node-red/runtime/lib/storage')` or a similar internal path. This
> is currently only catchable via `module:load` (future capability). Until
> `module:load` is implemented, `storage:*` cannot be enforced. The cap is
> designed now so the permission schema is correct when enforcement arrives.

---

### `registry:*` — what a package can do to the node type registry

Gates `RED.nodes.registerType()` and related registry operations.

| Capability | What it gates |
|---|---|
| `registry:register` | `RED.nodes.registerType(type, constructor)` — register a new node type or override an existing one |
| `registry:read` | `RED.nodes.getType(type)` — retrieve a node type's constructor/definition; `RED.nodes.getNodeList()` — list all registered type names |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `registry:all` | `registry:register` + `registry:read` |

> **Threat without `registry:register`:** a malicious package loaded at runtime
> could call `registerType('inject', MaliciousConstructor)` to silently replace
> a built-in node type. Every subsequent instance of that node type in the flow
> would run the attacker's code instead of the legitimate implementation.
>
> **Threat without `registry:read`:** `getType(type)` returns the actual
> constructor function. With it a package can inspect and mutate prototype
> methods on any node type, affecting all existing and future instances of that
> type. `getNodeList()` reveals the full list of installed node types, useful
> for fingerprinting a target installation.

---

### `settings:*` — what a package can do to the runtime settings object

Gates access to `RED.settings.*` as exposed through `createNodeApi`.

| Capability | What it gates |
|---|---|
| `settings:read` | Read any key from `RED.settings` |
| `settings:write` | Write / mutate any key on `RED.settings` |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `settings:all` | `settings:read` + `settings:write` |

> **Implementation note.** `RED.settings` is a plain object — there is no
> `require()` call to intercept. Gating reads and writes requires wrapping the
> settings object in a `Proxy` when it is attached to the `RED` object inside
> `createNodeApi`, the same approach needed for `process.env`.

---

### `hooks:*` — what message pipeline hooks a package can register

Gates `RED.hooks.add(hookName, fn)` and `RED.hooks.remove(hookName, fn)`
registrations. Each hook has its own cap so a package can be granted the
ability to observe delivered messages without being able to intercept outgoing
ones.

| Capability | What it gates |
|---|---|
| `hooks:on-send` | `RED.hooks.add('onSend', fn)` — called when a node calls `send()`, before routing |
| `hooks:pre-route` | `RED.hooks.add('preRoute', fn)` — before the message is routed to recipient nodes |
| `hooks:pre-deliver` | `RED.hooks.add('preDeliver', fn)` — before the message is delivered to a node's input handler |
| `hooks:post-deliver` | `RED.hooks.add('postDeliver', fn)` — after delivery to the input handler |
| `hooks:on-receive` | `RED.hooks.add('onReceive', fn)` — when a node begins processing a received message |
| `hooks:post-receive` | `RED.hooks.add('postReceive', fn)` — after the node's input handler completes |
| `hooks:on-complete` | `RED.hooks.add('onComplete', fn)` — when a node calls `done()` (message acknowledged) |
| `hooks:remove` | `RED.hooks.remove(hookName, fn)` — deregister a hook handler |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `hooks:message` | All 7 message pipeline hooks (excludes `hooks:remove`) — backward-compatible alias |
| `hooks:all` | All `hooks:*` above including `hooks:remove` |

> **Threat without `hooks:remove`:** a malicious package that obtains a
> reference to a hook function (e.g. via a shared module or by registering its
> own hook that captures the prior handler in a closure) could call
> `RED.hooks.remove()` to silently disable it — including Sentinel's own
> monitoring hooks.

---

### `http:*` — what HTTP routes and middleware a package can register

`httpAdmin` and `httpNode` are separate Express instances with different threat
profiles. Any package can attempt to register on either — routes are not
scoped to node type.

| Capability | What it gates |
|---|---|
| `http:admin` | Register routes or middleware on `httpAdmin` (admin UI, `/flows`, `/settings`, auth endpoints — highest privilege) |
| `http:node` | Register routes or middleware on `httpNode` (user-facing HTTP endpoints) |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `http:register` | `http:admin` + `http:node` |

---

### `events:*` — what a package can listen to or emit on the server-side event bus

`RED.events` is a Node.js `EventEmitter` used as an internal pub/sub bus
between Node-RED subsystems. Capabilities are dynamic — the event name is
part of the cap string.

| Capability | What it gates |
|---|---|
| `events:listen:<name>` | `RED.events.on(name, fn)` / `RED.events.once(name, fn)` for a specific event |
| `events:listen:*` | Listen to any event |
| `events:emit:<name>` | `RED.events.emit(name, ...)` for a specific event |
| `events:emit:*` | Emit any event |
| `events:remove-listeners:<name>` | `RED.events.removeListener(name, fn)` / `RED.events.removeAllListeners(name)` for a specific event |
| `events:remove-listeners:*` | Remove listeners for any event |

**Examples:**

```
events:listen:flows:started
events:listen:runtime-state
events:listen:node-status
events:listen:banana              # custom event emitted by another node
events:emit:my-plugin:ready
events:remove-listeners:my-topic  # remove own listeners on cleanup
```

> `events:listen:*`, `events:emit:*`, and `events:remove-listeners:*` are
> high-privilege shorthands. In practice, nodes should declare specific event
> names they need.
>
> **Threat without `events:remove-listeners`:** `RED.events.removeAllListeners(name)`
> wipes every handler for an event in one call — including those registered by
> Sentinel or other security packages for monitoring. A malicious package could
> silently blind all observers of a critical event.

---

### `process:*` — what OS-level operations a package can perform

| Capability | What it gates |
|---|---|
| `process:exec` | `child_process.exec()`, `execSync()`, `spawn()`, `spawnSync()`, `execFile()`, `execFileSync()`, `fork()` |
| `process:env:read` | Read from `process.env` |
| `process:env:write` | Write to / mutate `process.env` |
| `process:exit` | `process.exit()`, `process.abort()` — terminate the Node-RED process entirely |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `process:env` | `process:env:read` + `process:env:write` |
| `process:env:write` | `process:env:write` + `process:env:read` (write implies read) |
| `process:all` | `process:exec` + `process:env:read` + `process:env:write` + `process:exit` |

> **Implementation note — `process:env` and `process:exit`:** `process` is a
> global object, not a module — there is no `require('process')` call to
> intercept via `Module._load`. Gating `process:env:*` requires wrapping
> `process.env` in a `Proxy` (or using `Object.defineProperty`) at preload
> time. Gating `process:exit` requires replacing `process.exit` and
> `process.abort` with guarded wrappers at preload time. Both must happen
> before any node package loads.

---

### `network:*` — what outbound network calls a package can make

Enforced by both the runtime preload (for node code) and the Service Worker
(for browser fetch calls from the editor).

| Capability | What it gates |
|---|---|
| `network:http` | Outbound `http.request()` / `https.request()` / `http.get()` via the `http`/`https` built-in modules |
| `network:fetch` | `globalThis.fetch()` |
| `network:socket` | Outbound raw TCP/UDP/TLS via `require('net').createConnection()`, `require('dgram').createSocket()`, `require('tls').connect()` — these bypass `network:http` entirely |
| `network:dns` | DNS lookups via `require('dns')` / `require('dns/promises')` / `require('node:dns')` — a known data-exfiltration channel (DNS tunneling encodes data as subdomains queried against an attacker-controlled nameserver) |
| `network:listen` | Inbound connections: `http.createServer()`, `https.createServer()`, `net.createServer()` — opens a listening port on the host (backdoor vector) |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `network:all` | `network:http` + `network:fetch` + `network:socket` + `network:dns` + `network:listen` |

> The network allowlist (`sentinel.networkPolicy.allowlist`) controls **which
> URLs** are reachable for `network:http` and `network:fetch`. The `network:*`
> capabilities control **whether** a node is allowed to make outbound calls at
> all. Both checks must pass for HTTP/fetch.
>
> **Gap — `network:socket` has no allowlist equivalent.** The allowlist only
> applies to HTTP/fetch. A package granted `network:socket` can connect raw
> TCP/UDP to any host and port with no further restriction. A host/port
> allowlist for sockets is not yet designed.
>
> **Gap — `network:dns` has no allowlist equivalent.** DNS queries go to the
> system resolver and cannot be restricted by the HTTP allowlist. A domain
> allowlist for DNS would require a separate mechanism.

---

### `fs:*` — what file system operations a package can perform

Enforced by hooking `require('fs')` in the preload, the same mechanism used
for `require('http')` and `require('https')`.

| Capability | What it gates |
|---|---|
| `fs:read` | Read operations: `readFile`, `readFileSync`, `readdir`, `readdirSync`, `createReadStream`, `stat`, `statSync`, `exists`, `existsSync`, `open` (read mode), `watch`, `watchFile` |
| `fs:write` | Write operations: `writeFile`, `writeFileSync`, `appendFile`, `appendFileSync`, `createWriteStream`, `unlink`, `unlinkSync`, `mkdir`, `mkdirSync`, `rename`, `renameSync`, `open` (write mode) |

**Shorthands:**

| Shorthand | Expands to |
|---|---|
| `fs:all` | `fs:read` + `fs:write` |

> **Threat without this gate:** a node can freely `require('fs')` and read
> `settings.js` (extracts credential encryption key and admin passwords),
> `flows_cred.json` (raw encrypted credentials), `.env` files, or SSH keys.
> It can also overwrite flow and credential files directly, bypassing the
> entire HTTP deploy pipeline.
>
> **Implementation note — all `fs` module variants must be hooked.** The
> following all expose the same file system operations and must all be
> intercepted: `require('fs')`, `require('fs/promises')`, `require('node:fs')`,
> `require('node:fs/promises')`. Hooking only `require('fs')` leaves the other
> three as bypasses.
>
> **Gap — `fs:*` has no path allowlist.** A package granted `fs:read` can read
> any file on the host with no restriction on which paths are accessible. There
> is no mechanism to say "only read from `/data/`". A path allowlist for `fs`
> is not yet designed.

---

### `vm:*` — what a package can execute in isolated V8 contexts

Gates `require('vm')` usage. The `vm` module runs arbitrary JavaScript in a
separate V8 context that is **outside the reach of `Module._load` hooks** —
any `require()` calls made inside a `vm` script bypass Sentinel's interception
entirely.

| Capability | What it gates |
|---|---|
| `vm:execute` | `vm.runInNewContext()`, `vm.runInThisContext()`, `vm.runInContext()`, `vm.Script`, `vm.compileFunction()` |

> **Blocked by default.** Even with `vm:execute` granted, code run inside a
> `vm` context escapes all `Module._load` protections. This capability should
> only ever be granted in fully-audited, controlled circumstances.

---

### `threads:*` — what a package can do with worker threads

Gates `require('worker_threads')` usage. Worker threads run in a separate V8
isolate on a separate OS thread. The main thread's `Module._load` hook does
**not** cover code running inside a worker — each worker has its own module
loader.

| Capability | What it gates |
|---|---|
| `threads:spawn` | `new Worker(...)` — spawn a worker thread |

> **Blocked by default.** A worker thread spawned by a malicious package can
> `require()` any module, make any network call, and access the file system
> without any Sentinel hook firing. This capability should only ever be granted
> in fully-audited, controlled circumstances.

---

### `comms:*` — what a package can publish to the server-to-editor WebSocket channel

`RED.comms` pushes real-time updates from the server to the browser editor
(debug messages, node status badges, notifications).

| Capability | What it gates |
|---|---|
| `comms:publish` | `RED.comms.publish(topic, data)` — push a message to all connected editor clients |

> Without this gate a malicious node can push fake notifications or status
> updates to the operator's browser — a social engineering vector inside the
> editor UI.

---

## Top-level shorthand

| Shorthand | Expands to |
|---|---|
| `all` | Every capability listed in this document — the nuclear option. Should never appear in a production permissions file. Includes `vm:execute` and `threads:spawn`, which escape hook coverage entirely. |

---

## Notes on context stores

Node-RED's **flow context** and **global context** (`node.context().flow`,
`node.context().global`) are intentionally shared across nodes by design.
Gating them would break almost every real flow and is out of scope.

The `node:context:*` capabilities only gate the **cross-node path**: accessing
another node's **private node-level context** via a `getNode()` reference
(`thatNode.context().get(...)`). A node accessing its own context (`this
.context()`) is always allowed.

---

## Systemic gap: ESM `import()` bypasses all `Module._load` hooks

Every built-in gate in this document (`fs:*`, `network:http`, `process:exec`,
etc.) is enforced by wrapping the module returned from `require()` via the
`Module._load` hook. This mechanism only covers CommonJS `require()`.

ESM dynamic imports — `await import('fs')`, `await import('axios')` — use the
ESM loader, which does **not** call `Module._load`. A package written as an ES
module, or a CommonJS package that uses dynamic `import()`, bypasses every
single gate unconditionally.

**Scope of the bypass:**

| Gate | Bypassed by ESM `import()`? |
|---|---|
| `fs:*` | Yes — `await import('fs')` gives unwrapped fs |
| `network:http` | Yes — `await import('http')` gives unwrapped http |
| `process:exec` | Yes — `await import('child_process')` gives unwrapped child_process |
| `network:socket` | Yes |
| `network:dns` | Yes |
| `vm:execute` | Yes — `await import('vm')` is not blocked |
| `threads:spawn` | Yes — `await import('worker_threads')` is not blocked |
| `module:load` (future) | Yes — `import()` entirely bypasses `Module._load` |

**Current Node-RED context:** Node-RED node packages are predominantly
CommonJS. ESM node packages are rare but not impossible, and an attacker
writing a malicious package could deliberately use ESM to evade detection.

### Fix: ESM loader hooks

Node.js exposes a parallel hook system for the ESM loader. Since Node 18.19+
/ 20.6+, a custom loader can be registered from CJS code at boot:

```js
// inside preload-source.js, called before any node package loads
require('node:module').register(
    new URL('./esm-loader.mjs', 'file://' + __filename),
    { data: { allowMap, dangerousModules } }
);
```

The loader file (`src/esm-loader.mjs`) exports a `resolve` hook that
intercepts every `import()` call before the module loads:

```js
export async function resolve(specifier, context, nextResolve) {
    const parentUrl  = context.parentURL; // file URL of the importing module
    const callerPkg  = extractPackageFromUrl(parentUrl); // same logic as CJS

    if (isDangerous(specifier) && !hasCapability(callerPkg, specifier)) {
        throw new Error(`NRG Sentinel: import('${specifier}') blocked`);
    }
    return nextResolve(specifier, context);
}
```

`context.parentURL` gives the file URL of the module calling `import()` —
the ESM equivalent of the `parent` parameter in `Module._load`. Package-name
extraction from a `file://` URL uses the same `node_modules/<pkg>` path
parsing already in `extractModuleFromFrame()`.

The ESM hook enables two enforcement strategies that can be combined:

**Strategy 1 — block at `resolve`:** for modules where the entire import is
dangerous and there are no granular sub-caps. The module never loads.

**Strategy 2 — allow through + wrap in `load` hook:** for modules with
granular method-level caps (e.g. `fs:read` vs `fs:write`). The `load` hook
intercepts the module source and returns a wrapped version, the same way the
CJS gate wraps methods after `Module._load`. This is more powerful than CJS
because wrapping happens before the caller's code ever receives the module.

| `import()` specifier | Strategy | Capability |
|---|---|---|
| `'vm'`, `'node:vm'` | Block at `resolve` | `vm:execute` |
| `'worker_threads'`, `'node:worker_threads'` | Block at `resolve` | `threads:spawn` |
| `'fs'`, `'fs/promises'`, `'node:fs'`, `'node:fs/promises'` | Allow + wrap in `load` | `fs:read` / `fs:write` at method call time |
| `'child_process'`, `'node:child_process'` | Allow + wrap in `load` | `process:exec` at method call time |
| `'http'`, `'https'`, `'node:http'`, `'node:https'` | Allow + wrap in `load` | `network:http` at method call time |
| `'net'`, `'dgram'`, `'tls'` | Allow + wrap in `load` | `network:socket` at method call time |
| `'dns'`, `'dns/promises'`, `'node:dns'` | Allow + wrap in `load` | `network:dns` at method call time |

### State sharing challenge

In Node 18/20, ESM loader hooks run in a **separate worker thread**. The main
thread's `allowMap` and capability grants are not directly accessible. Three
approaches in ascending complexity:

1. **Static snapshot** (simplest) — pass the full policy as `data` to
   `register()` at boot. Works for grants loaded from disk at startup. Does
   not reflect runtime grant changes, which is acceptable for most deployments
   since grants are configured before startup.

2. **`SharedArrayBuffer`** — serialise the policy into a shared buffer,
   updated atomically when grants change. Supports live updates but adds
   significant complexity.

3. **Node 22+** — ESM loader hooks run in the main thread. State is directly
   shared with no workaround needed. If the minimum supported Node version
   reaches 22, options 1 and 2 become unnecessary.

### What cannot be fixed

Static top-level `import` statements (e.g. `import fs from 'fs'` at the top
of a file) are resolved at parse time when the package file is first loaded.
The `resolve` hook does fire for these too — it fires for every import
regardless of whether it is static or dynamic. So static imports are covered.

The one genuine blind spot is a package declared as `"type": "module"` in its
`package.json`. Such a package is loaded via the ESM loader from the start,
meaning its top-level static imports are resolved before the CJS `Module._load`
hook even sees the package. The ESM `resolve` hook covers this — but only if
the ESM loader is registered early enough (before any ESM package loads), which
requires `register()` to be called at the very top of the preload before any
other `require()` or `import()`.

**Interim mitigation until the ESM loader is implemented** (see "Fix: ESM
loader hooks" above for the full implementation design)**:** detect `"type":
"module"` in a package's `package.json` during the CJS `Module._load` hook
(when the package's main file is first required) and block it. This is a
temporary safety measure — not a permanent policy. Without the ESM loader
hook active, an ESM package is a complete blind spot where every dangerous
`import()` goes unchecked. Blocking is safer than silently allowing an
unguarded package.

Once the ESM loader is registered via `require('node:module').register()`,
this block is lifted and ESM packages load normally under the same capability
rules as CJS packages. The end state is full ESM support with no restrictions
beyond those that apply to CJS.

How the interim block works:

```js
// inside Module._load hook, when a new node package is first seen
var pkgDir  = findPackageRoot(resolvedFilename); // walk up to find package.json
var pkgJson = JSON.parse(fs.readFileSync(path.join(pkgDir, 'package.json')));

if (pkgJson.type === 'module') {
    throw new Error(
        'NRG Sentinel: ESM package "' + pkgJson.name + '" blocked — ' +
        'ESM loader hook not yet active. ' +
        'Set NRG_SENTINEL_ALLOW_ESM=1 to bypass (unsafe).'
    );
}
```

`findPackageRoot` walks up the directory tree from `resolvedFilename` until it
finds a `package.json` — the same traversal Node uses for module resolution.
The read is cached by package directory to avoid repeated disk hits. The escape
hatch (`NRG_SENTINEL_ALLOW_ESM=1`) exists for operators who accept the risk
during development before the ESM loader is deployed.

---

## Suggested future capability: `module:load`

> **Not yet planned for implementation — read and decide later.**

### What `require()` actually accepts

`Module._load` receives every `require()` call regardless of the request type.
Three distinct forms arrive at the hook:

| Request form | Example | Goes through `Module._load`? |
|---|---|---|
| Package name | `require('axios')` | Yes |
| Relative file path | `require('./helper')`, `require('../util')` | Yes |
| Absolute file path | `require('/some/path/to/file')` | Yes |
| URL | `require('https://...')` | **No** — Node throws "Cannot find module". URLs are only supported by ESM `import()`, not CommonJS `require()`. |

All three path forms resolve through `Module._resolveFilename` to an absolute
path before loading. The `request` parameter the hook sees is always the raw
string the caller passed.

### What it would do

Gate what a package is allowed to load via `require()`. The capability string
encodes the request type:

```
module:load:<package-name>          — specific npm package     e.g. module:load:axios
module:load:./relative              — relative path load       e.g. module:load:./local-helper
module:load:*                       — any require() call (effectively disables the gate)
```

### Why it matters

A node's declared `package.json` dependencies already signal intent, but
nothing enforces it at runtime. A malicious package could `require('fs')`,
`require('child_process')`, or any package available in `node_modules` without
having declared it.

The file path forms add an extra threat: a node doing
`require('../../settings')` could load the Node-RED `settings.js` file and
extract its exports (credentials encryption key, admin passwords, database
URLs) without ever touching the file system directly via `fs`. This bypasses
the `fs:*` capability gate entirely because it goes through the module loader
instead.

A `module:load` gate makes both the dependency declaration and the file path
scope authoritative.

### Suggested implementation

The preload already hooks `Module._load`. The extension needed:

1. **Classify the request** on every `Module._load` call:
   - **Harmless built-ins** (`path`, `url`, `events`, `stream`, `buffer`,
     `util`, `crypto`, `querystring`, `os`, `assert`, `punycode`, etc.) →
     allow unconditionally, no capability check.
   - **Dangerous built-ins already gated by a dedicated capability group**
     (`fs` → `fs:*`, `child_process` → `process:exec`, `http`/`https` →
     `network:http`, `net`/`dgram`/`tls` → `network:socket`) → the capability
     check happens inside those groups when the returned module's methods are
     called, not at `require()` time. `module:load` does not add a second check
     on top.
   - **Dangerous built-ins with dedicated capability groups** (`vm` → `vm:execute`,
     `worker_threads` → `threads:spawn`) → block the `require()` call unless
     the caller holds the respective cap. Both are blocked by default.
   - **Relative or absolute path** (starts with `.`, `..`, or `/`) → see
     same-package and cross-package rules in steps 3–4.
   - **Package name** (everything else) → check `module:load:<name>`.

2. **Build a declared-dependency map at boot** — when the preload first sees
   `@node-red/registry` load a node package, read that package's
   `package.json` and record its `dependencies` + `peerDependencies` as the
   node's declared set. Packages in the declared set are implicitly granted
   without needing an explicit `module:load` entry.

3. **Same-package relative paths** — if the resolved absolute path falls inside
   the requiring package's own directory, allow it unconditionally. A package
   loading its own internal files is not a threat.

4. **Cross-package and absolute paths** — if the resolved path falls outside
   the requiring package's directory and is not a declared dependency, require
   an explicit `module:load` grant.

5. **Transitive dependencies** — when package A loads package B, and B loads
   package C, C is allowed because the requiring frame at that point is B
   (which declared C). The check is per-frame, not per-originating-package, so
   transitive loads resolve naturally.

6. **Native addons (`.node` files)** — apply the same check. Native addons are
   particularly dangerous because they escape the JavaScript sandbox entirely.

### Which capability gates what

`module:load` and the dedicated built-in capability groups are complementary
and non-overlapping — for any given resource you need one or the other, never
both:

```
require('fs')           — allowed unconditionally (module:load skips built-ins
                          that have a dedicated group)
fs.readFile(...)        — checked here → needs fs:read
fs.writeFile(...)       — checked here → needs fs:write

require('axios')        — checked here → needs module:load:axios
axios.get(...)          — no additional check (module:load covers the whole package)
```

`module:load:fs` is not a valid capability. `fs` is a built-in with its own
group (`fs:*`); it never goes through the `module:load` path. The gate for
built-ins fires at **method call time**, not at `require()` time — the same
pattern used for `http`/`https` (we wrap `request()`/`get()` rather than
blocking the `require()` call itself).

### Challenges to resolve before implementing

- **Cold-boot ordering** — the registry loads node packages before Sentinel has
  had a chance to build the dependency map for all of them. Need to either
  delay enforcement or do a two-pass scan.
- **Dynamic requires** — `require(someVariable)` where the module name is
  computed at runtime. The check still applies but the granted cap must use
  `module:load:*` unless the name can be statically determined.
- **Monorepo / workspace packages** — local packages resolved via symlinks may
  not have a canonical npm name. Need to handle the resolved-path case.
- **`fs:*` vs `module:load` overlap** — loading a JS/JSON file via `require()`
  is semantically a read operation but goes through the module loader, not
  `fs`. Both gates are complementary: `fs:read` covers raw file reads,
  `module:load` covers execution of loaded modules. Both should be required for
  full containment.
