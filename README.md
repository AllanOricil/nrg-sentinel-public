<p align="center">
  <img alt="nrg-sentinel-icon" src="https://gist.githubusercontent.com/AllanOricil/244c22dad889ed47ef6530e5bb605536/raw/b0b02ada070c2bc2d4970cf186866917a3af143b/nrg-sentinel-icon.svg" style="width: 200px"/>
</p>
<br/>
<p align="center">
  <a href="https://github.com/AllanOricil/nrg-sentinel-public/actions/workflows/release.yml"><img src="https://github.com/AllanOricil/nrg-sentinel-public/actions/workflows/release.yml/badge.svg" alt="Release"></a>
  <a href="https://github.com/AllanOricil/nrg-sentinel-public/actions/workflows/docker.yml"><img src="https://github.com/AllanOricil/nrg-sentinel-public/actions/workflows/docker.yml/badge.svg" alt="Docker"></a>
</p>

# NRG Sentinel

A security layer for Node-RED that detects and blocks common attack vectors at runtime without modifying the Node-RED core.

## E2E Test Results

The table below is updated automatically after each CI run on `main`.

<!-- DEMO-TEST-RESULTS:START -->
| # | Demo | Result | Node-RED |
|---|------|:------:|:--------:|
| 01 | Monkey Patching | ✅ | `4.1.7` |
| 02 | Hook Injection | ✅ | `4.1.7` |
| 03 | Credential Theft | ✅ | `4.1.7` |
| 04 | Wire Manipulation | ✅ | `4.1.7` |
| 05 | Direct Receive Injection | ✅ | `4.1.7` |
| 06 | Express Middleware | ✅ | `4.1.7` |
| 07 | EventEmitter Hijack | ✅ | `4.1.7` |
| 08 | Node Enumeration | ✅ | `4.1.7` |
| 09 | Prototype Pollution | ✅ | `4.1.7` |
| 10 | Flow File Tampering | ✅ | `4.1.7` |
| 11 | Message Provenance | ✅ | `4.1.7` |
| 12 | Settings.js Tampering | ✅ | `4.1.7` |
| 13 | Sentinel Source Tampering | ✅ | `4.1.7` |
| 14 | Express Route Backdoor | ✅ | `4.1.7` |
| 15 | Config Node Z-Forgery | ✅ | `4.1.7` |
| 16 | Symbol Property Bypass | ✅ | `4.1.7` |
| 17 | EventEmitter Enumeration | ✅ | `4.1.7` |
| 18 | Deep Stack Bypass | ✅ | `4.1.7` |
| 19 | HTTP Route Deletion | ✅ | `4.1.7` |
| 20 | Child Process Exec | ✅ | `4.1.7` |
| 21 | SW Fetch Interception | — | — | browser-only — verify via `start-interactive.sh` |
| 22 | FS Read | ✅ | `4.1.7` |
| 23 | Process Env Exfiltration | ✅ | `4.1.7` |
| 24 | Process Exit DoS | ✅ | `4.1.7` |
| 25 | VM Sandbox Escape | ✅ | `4.1.7` |
| 26 | Worker Thread Escape | ✅ | `4.1.7` |
| 27 | Network Socket Exfiltration | ✅ | `4.1.7` |
| 28 | Registry Type Hijack | ✅ | `4.1.7` |
| 29 | Settings Mutation | ✅ | `4.1.7` |
| 30 | Comms Publish Spoofing | ✅ | `4.1.7` |
| 31 | Context Permissions | ✅ | `4.1.7` |
| 32 | Flows Inject | ✅ | `4.1.7` |
| 33 | Node Event Hijack | ✅ | `4.1.7` |
| 34 | Config Node Credentials | ✅ | `4.1.7` |
_Last updated: 2026-03-18T03:18:54Z_
<!-- DEMO-TEST-RESULTS:END -->

## Demos

Each demo is a self-contained scenario that shows an attack against Node-RED and how Sentinel blocks it.

| #   | Demo                                                               | Attack vector                                                                    |
| --- | ------------------------------------------------------------------ | -------------------------------------------------------------------------------- |
| 01  | Monkey Patching                     | Overwrites Node-RED core functions at runtime                                    |
| 02  | Hook Injection                       | Registers malicious `onSend`/`onReceive` hooks                                   |
| 03  | Credential Theft                   | Reads decrypted credentials from live node instances                             |
| 04  | Wire Manipulation                 | Rewires flow connections to exfiltrate data                                      |
| 05  | Direct Receive Injection   | Bypasses auth chain via `node.receive()`                                         |
| 06  | Express Middleware               | Installs rogue HTTP middleware on the admin API                                  |
| 07  | EventEmitter Hijack             | Intercepts internal Node-RED events                                              |
| 08  | Node Enumeration                   | Maps every node in the runtime via `eachNode()`                                  |
| 09  | Prototype Pollution             | Pollutes `Object.prototype` to affect all objects                                |
| 10  | Flow File Tampering                | Modifies the flows file on disk                                                  |
| 11  | Message Provenance               | Detects and blocks injected messages via HMAC tagging                            |
| 12  | Settings.js Tampering            | Modifies settings.js at runtime to inject capability grants                      |
| 13  | Sentinel Source Tampering | Patches Sentinel's preload.js on disk to disable protection                      |
| 14  | Express Route Backdoor       | Registers a hidden admin API route via `httpAdmin.get()`                         |
| 15  | Config Node Z-Forgery         | Fakes config-node identity to bypass credential access rules                     |
| 16  | Symbol Property Bypass       | Uses Symbol-keyed properties to evade proxy guard interception                   |
| 17  | EventEmitter Enumeration   | Enumerates all `RED.events` listeners to map internal runtime wiring             |
| 18  | Deep Stack Bypass                 | Chains anonymous wrappers to push the malicious frame outside the guard window   |
| 19  | HTTP Route Deletion             | Deletes existing Express routes to disable authentication endpoints              |
| 20  | Child Process Exec               | Spawns a shell command via `child_process` to execute arbitrary OS commands      |
| 21  | SW Fetch Interception                      | Browser-only: editor script uses `fetch()` to exfiltrate data; Service Worker blocks it via the network-policy allowlist |
| 22  | FS Read                                     | Reads `settings.js` via `require('fs')` to extract the credential secret         |
| 23  | Process Env Exfiltration                | Reads `process.env` to harvest injected secrets and API keys                     |
| 24  | Process Exit DoS                       | Calls `process.exit()` from a message handler to kill the runtime                |
| 25  | VM Sandbox Escape                        | Uses `require('vm')` to run code outside Sentinel's `Module._load` hooks         |
| 26  | Worker Thread Escape                  | Spawns a worker thread whose module loader is invisible to Sentinel              |
| 27  | Network Socket Exfiltration          | Creates a raw TCP socket to bypass the HTTP URL allowlist                        |
| 28  | Registry Type Hijack                | Calls `registerType('inject', ...)` to silently replace a built-in node type     |
| 29  | Settings Mutation                 | Reads or writes `RED.settings` to extract the credential secret or add backdoors |
| 30  | Comms Publish Spoofing                | Pushes fake notifications to the editor via `RED.comms.publish()`                |
| 31  | Context Permissions             | Reads or writes another node's context store without a grant                     |
| 32  | Flows Inject                           | Injects a malicious node into the running flow via the flows API                 |
| 33  | Node Event Hijack                 | Spies on or silences another node's input handler via EventEmitter APIs          |
| 34  | Config Node Credentials    | Interactive: explores open / restricted / locked config-node credential access   |

## Capability grants

By default Sentinel blocks every privileged operation for every third-party package. A package that needs a capability must be explicitly granted it in `settings.js`.

For the complete capability reference — every capability string, what it gates, shorthand expansions, and known gaps — see **docs/capability-design.md**.

### Adding a grant

Grants live in the `sentinel.allow` map inside `settings.js`. Each key is an **npm package name** exactly as it appears in `node_modules/`; the value is an array of capability strings.

#### Node-RED core nodes do not need grants

Sentinel only applies capability checks to packages loaded from the Node-RED **userDir** (`{userDir}/node_modules/` or `{userDir}/nodes/`). Node-RED's own built-in nodes (`inject`, `debug`, `function`, `http request`, etc.) are part of the Node-RED installation itself and live outside the userDir, so Sentinel never gates them. You only need to add grants for **third-party packages** that users install into their userDir.

#### `registry:register` — required for every node package

Every node package must be granted `registry:register` so Sentinel allows it to call `RED.nodes.registerType()` at startup. Without this grant, Sentinel blocks the call, the node type is never registered, and Node-RED logs _"Waiting for missing types"_ indefinitely.

```js
// settings.js — minimal grant for a node package that needs no other privileges
module.exports = {
    sentinel: {
        allow: {
            "my-custom-node": ["registry:register"],
        },
    },
};
```

#### Common grants

```js
// settings.js
module.exports = {
    sentinel: {
        allow: {
            // A node that reads its own credentials (this.credentials) directly.
            // See "Credential access patterns" below for config-node and cross-node cases.
            "node-red-contrib-influxdb": ["registry:register", "node:credentials:read"],

            // A flow-auditing plugin that needs to inspect the runtime topology.
            "node-red-contrib-flow-auditor": [
                "registry:register",
                "node:list", // RED.nodes.eachNode()
                "node:wires:read", // read node.wires (output topology)
                "flows:read", // RED.runtime.flows.getFlows() / getFlow(id)
            ],

            // A tracing / APM plugin that hooks the message pipeline.
            // hooks:on-send fires before routing; hooks:post-deliver fires after delivery.
            "node-red-contrib-tracer": ["registry:register", "hooks:on-send", "hooks:post-deliver"],

            // A node that registers its own admin UI routes.
            // http:admin covers httpAdmin; http:node covers httpNode.
            "node-red-contrib-dashboard": ["registry:register", "http:admin", "http:node"],

            // A node that genuinely needs to run OS commands.
            "node-red-contrib-exec": ["registry:register", "process:exec"],

            // A node that reads files from disk (e.g. a CSV reader).
            "node-red-contrib-file-in": ["registry:register", "fs:read"],

            // A node that makes outbound HTTP calls.
            // network:http covers http.request/https.request.
            // Add specific URLs to sentinel.networkPolicy.allowlist to restrict further.
            "node-red-contrib-http-request": ["registry:register", "network:http"],

            // A plugin (no node types) that listens to runtime events.
            // Plugins are registered via the node-red.plugins key in package.json
            // and do not call registerType — no registry:register needed.
            "node-red-contrib-audit-logger": ["events:listen"],
        },
    },
};
```

Sentinel identifies the calling package at runtime by walking the call stack and extracting the `node_modules/<package>` segment from the nearest frame that does not belong to Node-RED or Sentinel itself. The match is against the npm package name exactly as it appears on disk.

### Credential access patterns

The capability needed (if any) depends on which node owns the credentials being read.

#### Reading a node's own credentials

A node reading `this.credentials` in its own constructor or message handler needs `node:credentials:read` granted to its own package:

```js
// node-red-contrib-my-api/index.js
module.exports = function (RED) {
    function MyApiNode(config) {
        RED.nodes.createNode(this, config);
        var apiKey = this.credentials.apiKey; // guarded: needs node:credentials:read
        this.on("input", function (msg) {
            // use apiKey ...
            this.send(msg);
        });
    }
    RED.nodes.registerType("my-api", MyApiNode);
};
```

```js
// settings.js
sentinel: {
    allow: {
        "node-red-contrib-my-api": ["registry:register", "node:credentials:read"],
    },
}
```

**Why the node needs an explicit grant to read its own credentials:** if any node could always read `this.credentials` without a grant, a compromised or malicious package that registers a node type would automatically get access to whatever credentials the operator stored for it — no configuration signal, no audit trail, nothing for the operator to review or approve. Requiring the explicit grant means the operator has consciously decided "I trust this package to handle credentials." It also makes the intent visible: you can scan `settings.js` and immediately see which packages touch credential data.

If credentials were silently self-readable, `node:credentials:read` would only be needed for cross-node access — but then the presence or absence of the grant would tell you nothing about whether a package handles its own secrets, removing half its value as an audit signal.

#### Reading credentials from a config node referenced in its config

Config node credentials are closed by default, the same as every other node type. A consumer that needs to access `configNode.credentials` directly must either hold `node:credentials:read` in its grant list, or be listed in the config node type's `nodeTypes` entry in `.sentinel-grants.json`.

The idiomatic pattern avoids the credential proxy entirely: the config node reads `this.credentials` in its own constructor (Sentinel only proxies nodes returned from `getNode()`, not a node's own `this`), stores the secret as a plain property, and consumers read that plain property:

```js
// node-red-contrib-influxdb/index.js
module.exports = function (RED) {
    function InfluxConfigNode(config) {
        RED.nodes.createNode(this, config);
        // Reads this.credentials on the raw this — not via a getNode() proxy.
        // No credential cap needed because Sentinel only guards getNode() return values.
        this.token = this.credentials.token;
        this.host = config.host;
    }
    RED.nodes.registerType("influxdb-config", InfluxConfigNode);

    function InfluxWriteNode(config) {
        RED.nodes.createNode(this, config);
        // Consumer reads the plain property — no credential cap needed.
        var configNode = RED.nodes.getNode(config.configId);
        this.on("input", function (msg) {
            writeToInflux(configNode.host, configNode.token, msg.payload);
            this.send(msg);
        });
    }
    RED.nodes.registerType("influxdb-write", InfluxWriteNode);
};
```

```js
// settings.js — no node:credentials:read needed for either package under this pattern
sentinel: {
    allow: {
        "node-red-contrib-influxdb": ["registry:register"],
    },
}
```

If a consumer accesses `configNode.credentials.token` directly via the proxy returned by `getNode()`, that access goes through Sentinel's capability check. The consumer's package needs `node:credentials:read`, or the config node type must list it in a `nodeTypes` entry.

#### Reading credentials from a node that is not a config node

If a node reads `.credentials` from an arbitrary non-config node, the **accessing package** must have `node:credentials:read` in its grant list. Sentinel walks the call stack from `getNode()` to identify the calling package and checks its grants:

```js
// node-red-contrib-reader/index.js — wants to read credentials from node-red-contrib-target
module.exports = function (RED) {
    function ReaderNode(config) {
        RED.nodes.createNode(this, config);
        this.on("input", function (msg) {
            var target = RED.nodes.getNode(config.targetId);
            // Sentinel identifies node-red-contrib-reader as the caller and checks
            // its grants — not the target node's owning package.
            var secret = target.credentials.secret;
            this.send(msg);
        });
    }
    RED.nodes.registerType("reader", ReaderNode);
};
```

```js
// settings.js — the ACCESSOR needs node:credentials:read, not the target's package
sentinel: {
    allow: {
        "node-red-contrib-reader":  ["registry:register", "node:credentials:read"],
        "node-red-contrib-target":  ["registry:register"],
    },
}
```

**How the dual-axis check works:** `node:credentials:read` in the accessor's grant list (step 2) is a broad capability — it lets that package read `.credentials` from any node it obtains via `getNode()`. The `nodeTypes` section in `.sentinel-grants.json` provides the complementary target-side control (step 1): the target node type's author can list exactly which caller packages are approved, granting them access without requiring a broad package grant. Either axis alone is sufficient to allow the access. If neither passes, the proxy returns `undefined` for `credentials`.

Sentinel also looks for a `.sentinel-grants.json` file in the **userDir** (next to `settings.js`). This file is the backing store for the **Sentinel editor panel** — the Node-RED UI exposes admin API routes that read and write it directly, so operators can manage grants through the browser without touching `settings.js`.

This separation is intentional. In hardened deployments `settings.js` is mounted read-only (the Docker section mounts it `:ro`) so it cannot be modified at runtime. `.sentinel-grants.json` lives in the writable userDir (`/data` in Docker), giving the UI panel a place to persist changes. The two files have different ownership: `settings.js` is managed by deployment tooling; `.sentinel-grants.json` is managed by the UI.

#### File format

The file has two top-level sections:

```json
{
    "packages": {
        "node-red-contrib-my-package": ["registry:register", "node:credentials:read"]
    },
    "nodeTypes": {
        "my-config-node": {
            "node:credentials:read": ["node-red-contrib-trusted-consumer"]
        }
    }
}
```

- **`packages`** — dynamic caller grants, equivalent to `settings.sentinel.allow`. Entries here are merged with `settings.js` at runtime. This is what the Sentinel UI writes when you add a package grant through the editor.
- **`nodeTypes`** — per-node-type target permissions. Keyed on the **target node's type**, each entry lists which caller packages are allowed to perform a given operation on nodes of that type. This is used to restrict (or explicitly allow) access to a specific node type independently of the caller's package grants.

#### Node-type permissions — real-world examples

**Grant specific packages access to a config node's credentials**

To list which packages may read a config node's credentials via `getNode(id).credentials`, add the config node type to `nodeTypes`:

```json
{
    "nodeTypes": {
        "influxdb": {
            "node:credentials:read": ["node-red-contrib-influxdb"]
        }
    }
}
```

Only `node-red-contrib-influxdb` gets step-1 access via the target allowlist. Any other package without `node:credentials:read` in its grant list is blocked.

**Document that no caller is listed for a config node type**

An empty array `[]` records that no package is an approved caller via the target-side check. It has the same effect as not having an entry — neither grants step-1 access. Use it to make the intent explicit in the grants file:

```json
{
    "nodeTypes": {
        "my-vault-config": {
            "node:credentials:read": []
        }
    }
}
```

No package can read credentials from `my-vault-config` nodes through the target-based check. A package that has `node:credentials:read` in its `packages` entry (either in `settings.js` or in the `packages` section of this file) can still override this — the `[]` only closes the target-based path, not the caller-based path.

**Allow multiple consumers, block all others**

```json
{
    "nodeTypes": {
        "mqtt-broker": {
            "node:credentials:read": [
                "node-red-contrib-mqtt-in",
                "node-red-contrib-mqtt-out",
                "node-red-contrib-mqtt-dynamic"
            ]
        }
    }
}
```

**Restrict wire rewiring to a specific tool package**

```json
{
    "nodeTypes": {
        "function": {
            "node:wires:write": ["node-red-contrib-flow-manager"],
            "node:wires:read":  ["node-red-contrib-flow-manager", "node-red-contrib-flow-auditor"]
        }
    }
}
```

**Complete example combining both sections**

```json
{
    "packages": {
        "node-red-contrib-influxdb":   ["registry:register", "node:credentials:read"],
        "node-red-contrib-flow-audit": ["registry:register", "node:list"]
    },
    "nodeTypes": {
        "influxdb": {
            "node:credentials:read": ["node-red-contrib-influxdb"]
        },
        "mqtt-broker": {
            "node:credentials:read": ["node-red-contrib-mqtt-in", "node-red-contrib-mqtt-out"]
        },
        "my-internal-config": {
            "node:credentials:read": []
        }
    }
}
```

The `nodeTypes` section is purely additive: if the caller is in the list, access is granted immediately. If it is not, Sentinel falls through to the `packages` section and `settings.js` grants as normal. An entry here cannot block a package that already holds the capability in its grants.

### Grants are per package, not per node type

A single npm package can register many node types, but all of them share the same package name in the call stack. Sentinel cannot distinguish `my-package/nodes/foo.js` from `my-package/nodes/bar.js` at the frame level — both resolve to `my-package`. This is intentional: the **package** is the unit you install, audit, and sign off on.

### Fine-grained control with scoped child packages

If you need different capability levels for different node types, publish each trust boundary as its own scoped package and group them under a parent that users install as a single dependency.

**Parent package** — a dependency aggregator with no node code of its own:

```json
{
    "name": "@my-company/nodes",
    "version": "1.0.0",
    "dependencies": {
        "@my-company/node-data-formatter": "^1.0.0",
        "@my-company/node-mqtt-enricher": "^1.0.0",
        "@my-company/node-flow-auditor": "^1.0.0"
    }
}
```

**Child packages** — each has its own `node-red` field and npm identity:

```json
{
    "name": "@my-company/node-mqtt-enricher",
    "version": "1.0.0",
    "node-red": { "nodes": { "mqtt-enricher": "index.js" } }
}
```

When a user runs `npm install @my-company/nodes`, npm (v7+) hoists the children to the top-level `node_modules/`. Node-RED discovers them directly because each has its own `node-red` field. Sentinel sees each child's package name independently, so grants can be applied at exactly the right granularity:

```js
sentinel: {
    allow: {
        // formatter needs no privileged access — registry:register is enough
        "@my-company/node-data-formatter": ["registry:register"],
        // enricher reads credentials from a config node
        "@my-company/node-mqtt-enricher":  ["registry:register", "node:credentials:read"],
        // auditor needs to walk the full node graph
        "@my-company/node-flow-auditor":   ["registry:register", "node:list", "node:wires:read"],
    },
}
```

This pattern is already established in the Node-RED ecosystem — `@node-red/nodes`, `@node-red/runtime`, and `@node-red/editor-api` are all separate packages under the `@node-red` namespace.

### Service nodes as capability brokers

Sentinel resolves capabilities by looking at the **nearest** user-installed package in the call stack. This means a "service" package that wraps privileged operations acts as a capability broker: only the service needs the grant, not the packages that call into it.

**How it works:** When package A calls a method in package B, and package B internally makes a privileged call (e.g. `fs.readFileSync`), the call stack looks like this:

```
fs.readFileSync          ← built-in (skipped)
node-red-contrib-file-service/index.js:55   ← nearest userDir frame → checked
node-red-contrib-my-processor/index.js:12   ← outer frame (not checked for this call)
```

Sentinel finds `node-red-contrib-file-service` first and checks its grants. `node-red-contrib-my-processor` is not involved in the capability check at all.

**In practice:** publish a service package that wraps privileged operations behind a controlled API, grant it the capabilities it needs, and let consumer packages call it freely:

```js
// node-red-contrib-file-service/index.js
// This package holds fs:read — consumers don't need it.
module.exports = function (RED) {
    function FileServiceNode(config) {
        RED.nodes.createNode(this, config);
        // Exposed API — consumers call node.readConfig(), not fs directly.
        this.readConfig = function (filePath) {
            return require("fs").readFileSync(filePath, "utf8");
        };
    }
    RED.nodes.registerType("file-service", FileServiceNode);
};
```

```js
// node-red-contrib-my-processor/index.js
// No fs capability needed — reads files through the service node.
module.exports = function (RED) {
    function ProcessorNode(config) {
        RED.nodes.createNode(this, config);
        var service = RED.nodes.getNode(config.serviceId);
        this.on("input", function (msg) {
            var data = service.readConfig("/data/config.json"); // service makes the fs call
            // ... process data
            this.send(msg);
        });
    }
    RED.nodes.registerType("my-processor", ProcessorNode);
};
```

```js
// settings.js
sentinel: {
    allow: {
        // Only the service needs fs:read — it owns the privileged boundary.
        "node-red-contrib-file-service": ["registry:register", "fs:read"],
        // The consumer needs no capability beyond registering its node type.
        "node-red-contrib-my-processor": ["registry:register"],
    },
}
```

This pattern is useful when multiple consumer packages need the same privileged operation: centralise it in one well-audited service package, grant only that package the capability, and consumers remain unprivileged. The service becomes the policy enforcement point — it decides what it exposes, and Sentinel enforces that nothing bypasses it.

## Defense architecture

Sentinel runs inside the same Node.js process as every package it protects against — there is no sandbox, no separate process, and no OS-level isolation. Meaningful enforcement in that environment requires layered hardening techniques:

| Layer | Technique | What it closes |
|---|---|---|
| 0 — Prototype hardening | `Object.preventExtensions` on all built-in prototypes | Prototype pollution before any third-party code runs |
| 1 — Module interception | `Module._load` hook + non-configurable lock | `require()` of `fs`, `http`, `child_process`, `vm`, `worker_threads` |
| 2 — Node isolation | ES6 `Proxy` on every `getNode()` return value | Property reads, writes, and `defineProperty` on live node instances |
| 3 — Surface hardening | Guarded Express routing, `process.env` Proxy, router-stack Proxy | Post-init manipulation of the HTTP server and environment |
| 4 — Network policy | Outbound HTTP/HTTPS/socket allowlist | Exfiltration paths not covered by the module gate |
| Cross-cutting | Intrinsic capture, call-stack introspection, file integrity watchdog | Prototype mutation of guard helpers, call-identity forgery, on-disk tampering |

All built-in methods used by guard logic are pinned as standalone bound functions before the first `require()`, so a package that overwrites `String.prototype.includes` cannot blind the stack-frame checks. The `Module._load` hook is locked `configurable: false` immediately after installation so it cannot be stripped. Every node proxy intercepts `defineProperty` in addition to `get`/`set`, closing the bypass that would otherwise let a caller install a getter on a proxied node.

For the full reference — every technique explained with code examples and attack scenarios — see **[docs/defense-techniques.md](docs/defense-techniques.md)**.


## Module access gates

Sentinel intercepts `require()` for dangerous built-in modules and blocks specific methods within them. When a call is blocked, Sentinel prints a warning to the Node-RED console and tells you exactly which grant to add.

The warning format is:

```
[@allanoricil/nrg-sentinel] BLOCKED fs.readFileSync() — my-custom-node lacks fs:read
  Call stack:
    at Object.<anonymous> (/data/node_modules/my-custom-node/index.js:42:5)
  To allow, add to settings.js:
    sentinel: { allow: { "my-custom-node": ["fs:read"] } }
```

For modules that are blocked entirely at `require()` time (like `vm` and `worker_threads`), the operation throws immediately:

```
[@allanoricil/nrg-sentinel] BLOCKED require('vm') — my-custom-node lacks vm:execute
```

### File system — `fs:read` and `fs:write`

Triggered by `require('fs')`, `require('fs/promises')`, `require('node:fs')`, `require('node:fs/promises')`.

| What you call                                                                                | Cap needed |
| -------------------------------------------------------------------------------------------- | ---------- |
| `readFile`, `readFileSync`, `readdir`, `createReadStream`, `stat`, `exists`, `watch`         | `fs:read`  |
| `writeFile`, `writeFileSync`, `appendFile`, `createWriteStream`, `unlink`, `mkdir`, `rename` | `fs:write` |

```js
// Node-RED log when blocked:
// [@allanoricil/nrg-sentinel] BLOCKED fs.readFileSync() — my-node lacks fs:read

sentinel: {
    allow: {
        "my-node": ["registry:register", "fs:read"],
    },
}
```

### Outbound HTTP — `network:http` and `network:fetch`

Triggered when a node calls `http.request()`, `https.request()`, `http.get()`, or the global `fetch()`.

```js
// Node-RED log when blocked:
// [@allanoricil/nrg-sentinel] BLOCKED http.request() — my-node lacks network:http
// NRG Sentinel: network:fetch not granted — my-node

sentinel: {
    allow: {
        "my-node": ["registry:register", "network:http"],
    },
}
```

You can further restrict which URLs are reachable using the network allowlist:

```js
sentinel: {
    allow: {
        "my-node": ["registry:register", "network:http"],
    },
    networkPolicy: {
        allowlist: [
            "https://api.example.com/",
            "https://metrics.internal/",
        ],
    },
}
```

### Raw TCP/UDP sockets — `network:socket`

Triggered by `net.createConnection()`, `tls.connect()`, `dgram.createSocket()`. These bypass the HTTP URL allowlist entirely — a package with only `network:http` cannot open raw sockets.

```js
// Node-RED log when blocked:
// [@allanoricil/nrg-sentinel] BLOCKED net.createConnection() — my-node lacks network:socket

sentinel: {
    allow: {
        "my-node": ["registry:register", "network:socket"],
    },
}
```

### DNS lookups — `network:dns`

Triggered by `require('dns').lookup()`, `resolve()`, and all other dns methods, including `dns/promises` variants. DNS is a known data-exfiltration channel (subdomains can encode data to an attacker-controlled nameserver).

```js
// Node-RED log when blocked:
// [@allanoricil/nrg-sentinel] BLOCKED dns.lookup() — my-node lacks network:dns

sentinel: {
    allow: {
        "my-node": ["registry:register", "network:dns"],
    },
}
```

### Child processes — `process:exec`

Triggered by `child_process.exec()`, `execSync()`, `spawn()`, `spawnSync()`, `execFile()`, `fork()`.

```js
// Node-RED log when blocked:
// [@allanoricil/nrg-sentinel] BLOCKED child_process.execSync() — process:exec not granted for my-node

sentinel: {
    allow: {
        "my-node": ["registry:register", "process:exec"],
    },
}
```

### Environment variables — `process:env:read`

Triggered when a node reads `process.env.SOME_KEY`. This gates reads from the global `process.env` object.

```js
// Node-RED log when blocked:
// [@allanoricil/nrg-sentinel] BLOCKED process.env.DATABASE_URL — my-node lacks process:env:read

sentinel: {
    allow: {
        "my-node": ["registry:register", "process:env:read"],
    },
}
```

### VM contexts — `vm:execute`

The entire `require('vm')` call is blocked if the caller lacks this capability. Code run inside a `vm` context bypasses all `Module._load` hooks — Sentinel cannot see what it does.

```js
// Node-RED log when blocked (throws, does not just warn):
// [@allanoricil/nrg-sentinel] BLOCKED require('vm') — my-node lacks vm:execute

sentinel: {
    allow: {
        "my-node": ["registry:register", "vm:execute"],
    },
}
```

### Worker threads — `threads:spawn`

The entire `require('worker_threads')` call is blocked. Workers run in a separate V8 isolate whose module loader is invisible to Sentinel.

```js
// Node-RED log when blocked (throws, does not just warn):
// [@allanoricil/nrg-sentinel] BLOCKED require('worker_threads') — my-node lacks threads:spawn

sentinel: {
    allow: {
        "my-node": ["registry:register", "threads:spawn"],
    },
}
```

## Local / Host install

Install Sentinel into your Node-RED user directory:

```bash
cd ~/.node-red
npm install @allanoricil/nrg-sentinel
```

Node-RED auto-discovers plugins in `~/.node-red/node_modules/`, so the Sentinel sidebar and plugin features load automatically on the next restart. No extra configuration is needed for that.

To activate the **preload guard** (module-level interception), set `NODE_OPTIONS` before starting Node-RED:

```bash
NODE_OPTIONS="--require @allanoricil/nrg-sentinel/preload" node-red
```

To make this permanent, add it to your startup script, systemd unit, or shell profile:

```bash
# ~/.bashrc or ~/.zshrc
export NODE_OPTIONS="--require @allanoricil/nrg-sentinel/preload"
```

> **Why not `./node_modules/.bin/node-red`?**
> The `node-red` package itself is not installed inside `~/.node-red` — it lives in the global `node_modules`. The Sentinel wrapper binary handles both cases automatically: when `node-red` is co-installed in the same `node_modules` tree (Docker) it resolves the entrypoint directly; otherwise it finds `node-red` via PATH. Either way, the preload is injected via `NODE_OPTIONS`.

## Docker

The [`Dockerfile`](Dockerfile) produces a hardened production image. The security model rests on three layers.

### Filesystem layout

```
/usr/src/nodered   owned by root, chmod a-w   Node-RED + Sentinel install
/etc/nodered       owned by root, chmod a-w   settings.js (read-only config)
/data              owned by nodered           flows, credentials, custom nodes
```

The Node-RED process runs as the unprivileged `nodered` user. It can read everything it needs and write only to `/data`. It cannot modify the Sentinel or Node-RED installation on disk, even if a malicious custom node executes code inside the process.

The write bit is stripped from `/usr/src/nodered` for **everyone, including root** (`chmod -R a-w`). Any attempt to silently patch Sentinel or Node-RED would require an explicit `chmod` first — which is visible in audit logs.

### Why `settings.js` lives in `/etc/nodered`

`settings.js` controls the capability grants for every node. Moving it out of `/data` (the writable zone) means a malicious node cannot edit the file to grant itself new permissions at runtime. It is mounted read-only from the host:

```bash
-v $(pwd)/settings.js:/etc/nodered/settings.js:ro
```

### Why the entrypoint is an absolute path

The `ENTRYPOINT` hardcodes the full path to Sentinel's wrapper binary:

```
dumb-init -- node /usr/src/nodered/node_modules/@allanoricil/nrg-sentinel/bin/node-red.js
```

This bypasses `node_modules/.bin/` entirely. A malicious package that declares `"bin": { "node-red": "..." }` in its `package.json` cannot displace the entrypoint because the container never resolves it through PATH or npm's bin symlinks.

`dumb-init` runs as PID 1 and correctly forwards OS signals (e.g. `SIGTERM` from `docker stop`) to Node-RED, solving the standard PID 1 signal-forwarding problem and ensuring graceful shutdown.

The wrapper:

1. Verifies `settings.js` signature before Node-RED starts (if `NRG_SENTINEL_PUBLIC_KEY` is set)
2. Injects the Sentinel preload by prepending `--require preload.js` to `NODE_OPTIONS`, then spawns the real `node-red` binary

In the Docker image both packages share `/usr/src/nodered/node_modules/`, so the wrapper resolves the `node-red` JS entrypoint via `require.resolve` and runs it with `node` directly. When installed in a userDir (`~/.node-red`) the fallback is to find `node-red` in PATH.

### Quick start

Pre-built images are published to Docker Hub on every release:

```bash
docker pull allanoricil/nrg-sentinel:latest
# or pin to a specific version
docker pull allanoricil/nrg-sentinel:1.2.3
```

To build from source instead:

```bash
docker build -t nrg-sentinel .
```

```bash
# Run (no signature verification)
docker run -p 1880:1880 \
  -v $(pwd)/settings.js:/etc/nodered/settings.js:ro \
  -v $(pwd)/data:/data \
  allanoricil/nrg-sentinel:latest

# Run (with signature verification)
docker run -p 1880:1880 \
  -v $(pwd)/settings.js:/etc/nodered/settings.js:ro \
  -v $(pwd)/settings.js.sig:/etc/nodered/settings.js.sig:ro \
  -v $(pwd)/data:/data \
  -e NRG_SENTINEL_PUBLIC_KEY=/run/secrets/sentinel.pub \
  --mount type=secret,id=sentinel_pub,target=/run/secrets/sentinel.pub \
  allanoricil/nrg-sentinel:latest
```

## Licensing

NRG Sentinel is source-available software with a commercial license for production use beyond the built-in 14-day trial. No license key is required to evaluate the product.

### License verification — offline only

License keys are verified **entirely on the local machine**. No data is sent to any server during verification, and no internet connection is required at any point.

A license key is a signed token in the form `<base64url(payload)>.<Ed25519-signature>`. The payload is a JSON object with the following fields:

| Field     | Description                                                                         |
| --------- | ----------------------------------------------------------------------------------- |
| `product` | Always `nrg-sentinel` — prevents a key issued for another product from being reused |
| `tier`    | License tier: `trial`, `pro`, `enterprise`, or `oem`                                |
| `exp`     | Unix timestamp of expiry; `0` means perpetual                                       |
| `cid`     | Customer identifier (email or UUID) — recorded in the Sentinel startup log          |

Verification steps performed locally at startup:

1. Decode and verify the Ed25519 signature against the public key baked into the distribution
2. Confirm `product === "nrg-sentinel"`
3. If `exp !== 0`, confirm the current time has not passed the expiry timestamp

The Ed25519 public key is embedded directly in `plugin.js` at build time (`SENTINEL_LICENSE_PUBLIC_KEY=<64-char-hex> node build.js`) and then obfuscated along with the rest of the plugin source. The corresponding private key is never included in the distribution and is never transmitted. An attacker who extracts the public key from the binary cannot forge a license — Ed25519 signatures are computationally infeasible to produce without the private key.

### What is never sent anywhere

- Your license key or customer ID
- The Node-RED host name, IP address, or any machine fingerprint
- Any flow, node, credential, or payload data

Sentinel makes no outbound network calls for licensing purposes. This is a deliberate design decision: NRG Sentinel is routinely deployed in restricted, air-gapped, or regulated environments where phone-home behaviour would be a hard blocker.

### Online activation

The npm package uses **offline-only** verification. There is no license server, no activation endpoint, and no requirement for internet access — now or after deployment.

If you need centrally managed license revocation (for example, if you are embedding Sentinel in an OEM product and need to rotate keys without reinstalling), the Sentinel Launcher binary supports optional online activation. Contact us for details.

### Trial period

The 14-day trial is counted from the first time Sentinel initialises in a given Node-RED instance. During the trial all features are fully available. After the trial expires, Sentinel remains active and continues blocking threats, but certain management features (such as the Permissions UI) require a valid license key.

### Configuring a license key

```js
// settings.js
module.exports = {
    sentinel: {
        license: "eyJ...", // license key issued by NRG
    },
};
```

Alternatively, set the `NRG_SENTINEL_LICENSE` environment variable — useful in containerised deployments where `settings.js` is mounted read-only.
