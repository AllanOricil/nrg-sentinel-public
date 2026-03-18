## [1.0.3](https://github.com/AllanOricil/nrg-sentinel/compare/v1.0.2...v1.0.3) (2026-03-18)


### Bug Fixes

* **release:** move landing page to repo root for GitHub Pages ([c1a1844](https://github.com/AllanOricil/nrg-sentinel/commit/c1a18442e498561e60e1ac1d9144ed33afd76d21))

## [1.0.2](https://github.com/AllanOricil/nrg-sentinel/compare/v1.0.1...v1.0.2) (2026-03-18)


### Bug Fixes

* **release:** sync _public-repo/site/ to public repo on release ([3cb627b](https://github.com/AllanOricil/nrg-sentinel/commit/3cb627ba420c6eae248a6fbcbb55e62d06fe3cf4))

## [1.0.1](https://github.com/AllanOricil/nrg-sentinel/compare/v1.0.0...v1.0.1) (2026-03-18)


### Bug Fixes

* close config-node credential access by default ([b968e08](https://github.com/AllanOricil/nrg-sentinel/commit/b968e089078521b04aaf2f973dd0385b7083979c))
* **e2e:** grant node:read to demo 34 readers and fix stale Demo 35 labels ([5737e9b](https://github.com/AllanOricil/nrg-sentinel/commit/5737e9bf5a31feb65978ae15b44a90ac00709047))
* **launcher:** update support contact email and minor style fixes ([9964b02](https://github.com/AllanOricil/nrg-sentinel/commit/9964b0275be71749d561f3b1ec113e1635e0eb96))
* replace placeholder URLs with allanoricil.github.io/nrg-sentinel-public ([46b9eca](https://github.com/AllanOricil/nrg-sentinel/commit/46b9ecaf65517da6507910898a34b0501b328098))

# 1.0.0 (2026-03-17)


### Bug Fixes

* add publishConfig access:public to dist/package.json ([345814b](https://github.com/AllanOricil/nrg-sentinel/commit/345814b8adb21be53e6715b002834b1d14e94899))
* add repository.url to dist/package.json for npm provenance ([09bbfba](https://github.com/AllanOricil/nrg-sentinel/commit/09bbfba50a8196da28c1fc82211d6c219b407f99))
* **ci:** deduplicate artifact filenames so all 18 results survive merge ([3d815c6](https://github.com/AllanOricil/nrg-sentinel/commit/3d815c61c734a004a8f0ad10c64bdeb013720c66))
* commit missing @node-red/fake-nodes test fixture ([e24e796](https://github.com/AllanOricil/nrg-sentinel/commit/e24e796d39d78df5c5523fb54475fee864327dfb))
* correct NRG hex icon, glow behind SVG, and sidebar tab badge visibility ([348db51](https://github.com/AllanOricil/nrg-sentinel/commit/348db517d1ed1289a009487b901ae0fa737ab3b1))
* **demo-18:** fix failing deep stack bypass demo ([909b287](https://github.com/AllanOricil/nrg-sentinel/commit/909b287a6f6466d39cf299a424744f70da4a093f))
* detect scoped config nodes via absence of x/y coords, not z==="" ([3737bbe](https://github.com/AllanOricil/nrg-sentinel/commit/3737bbedc0cf43701e334b81b67f36661a60c67e))
* exclude 'unknown' node type from Node Permissions list ([39d4184](https://github.com/AllanOricil/nrg-sentinel/commit/39d418428df2e62f2e1f2be7965a96485382d2df))
* glow via drop-shadow filter on SVG; fix badge nested-<a> bug ([50b6499](https://github.com/AllanOricil/nrg-sentinel/commit/50b64994ed5d2cf9093a15ad1ed4e07b609dc3d1))
* landing page hero columns and copy buttons; improve header badge icon ([f99a0af](https://github.com/AllanOricil/nrg-sentinel/commit/f99a0affefba5f18604179e483623eb37a8b88da))
* let public repo semantic-release own the tag and npm publish ([6e534a5](https://github.com/AllanOricil/nrg-sentinel/commit/6e534a5cfc0aaa55c424dc7d2bd4063244b0d78e))
* make bin wrapper work for both Docker (require.resolve) and userDir (PATH) ([120fc5e](https://github.com/AllanOricil/nrg-sentinel/commit/120fc5e589625748e8f7eeff27dcf6added19c7e))
* pin remaining intrinsics, add copyright headers, fix e2e tests 15 and 18 ([c20fa9a](https://github.com/AllanOricil/nrg-sentinel/commit/c20fa9a14a57c5385db5405864ad99d3c59cd424))
* pin WeakMap intrinsics to prevent prototype tampering ([146e93f](https://github.com/AllanOricil/nrg-sentinel/commit/146e93f7c9c5bca64d16f8e1afd166b92d2fee34))
* read .sentinel-license file on startup; fix license dialog UI ([e0e9b60](https://github.com/AllanOricil/nrg-sentinel/commit/e0e9b600124cccf208f1a6a23dfab1f944149d8e))
* remove z==="" fallback — WeakMap is always populated before proxy creation ([fb93ecb](https://github.com/AllanOricil/nrg-sentinel/commit/fb93ecb7b14d34794b6be103e235fc12ac025e52))
* rename .sentinel-permissions.json → .sentinel-grants.json in docs and tests ([6c5fe6a](https://github.com/AllanOricil/nrg-sentinel/commit/6c5fe6a789418ae6ee887633ed8ce5c8519f7f3f))
* resolve lint errors introduced by safe deployment feature ([0cbf03c](https://github.com/AllanOricil/nrg-sentinel/commit/0cbf03ce86505d0d0650b9d8d1635cf0fe593279))
* resolve node-red via PATH instead of require.resolve in bin wrapper ([6bde060](https://github.com/AllanOricil/nrg-sentinel/commit/6bde060523d64ac1b5dcb25e63a68fbd895f62ee))
* restore contents: read permission lost when actions: read was added ([cce680d](https://github.com/AllanOricil/nrg-sentinel/commit/cce680d8068eb49d713f29fa8f1fbab3ac2d7767))
* scope Run-column strip to E2E block and copy docs/ in sync script ([d8cb96e](https://github.com/AllanOricil/nrg-sentinel/commit/d8cb96e6489bb074b31d061d8e81481c63c81341))
* show trial/expired notification only once per session ([c48fb68](https://github.com/AllanOricil/nrg-sentinel/commit/c48fb68bc7c2be1c2c77286594fe7bf58b778a48))
* sync .github, .releaserc.json and .gitignore to public repo ([9ddc1cb](https://github.com/AllanOricil/nrg-sentinel/commit/9ddc1cb438431f01cbd983725d4cdb047d7c1eec))
* update e2e test 03 and integration test to use .sentinel-grants.json ([167194b](https://github.com/AllanOricil/nrg-sentinel/commit/167194b1f6349615cd88e49921b1242da44ac4d5)), closes [#summary-](https://github.com/AllanOricil/nrg-sentinel/issues/summary-)
* use process.argv[1] in bin/node-red.js to find co-installed node-red ([fd5473d](https://github.com/AllanOricil/nrg-sentinel/commit/fd5473dfe0ff40362ae56bc220df889e7403b5f5))
* use runner.name to resolve job ID for summary anchor ([8a5080e](https://github.com/AllanOricil/nrg-sentinel/commit/8a5080ea23094876c6bfe73c1f1e4ce8f4c2f6b1))


### Features

* add '0 dependencies' stat to landing page hero stats bar ([10d0b9b](https://github.com/AllanOricil/nrg-sentinel/commit/10d0b9bc937124020f13a5913d5270def9c90f50))
* add deployment review UI with visual flow diff ([fd46d9e](https://github.com/AllanOricil/nrg-sentinel/commit/fd46d9ea9b72be1ec6299c1b1fef76802a8c7d74))
* add e2e demo 31 — Context Permissions ([c7a63ac](https://github.com/AllanOricil/nrg-sentinel/commit/c7a63ac08e8a876591ab42909619b999b0b1b3d0))
* add e2e tests 20-30, fix all demo verdicts, strengthen CI ([235d963](https://github.com/AllanOricil/nrg-sentinel/commit/235d9633bf95c5dcd6cd0653ba8cf9467f13071c))
* add pending deployments banner in Sentinel sidebar ([e07ef42](https://github.com/AllanOricil/nrg-sentinel/commit/e07ef42d2089b6d35cabea049b98e75e0f8d87fb))
* add release workflow with semantic-release and build pipeline ([ff38bfe](https://github.com/AllanOricil/nrg-sentinel/commit/ff38bfeaff56de131e902588ad38cab3004d496c))
* add safe deployment queue module ([8917212](https://github.com/AllanOricil/nrg-sentinel/commit/8917212a511215b51f91c8f10b177deb1c6ef96f))
* add structural flow diff engine ([0d52969](https://github.com/AllanOricil/nrg-sentinel/commit/0d52969ae39ce97cf2127608340ce05a1ee4104a))
* add two-repo distribution pipeline, landing page, and licensing docs ([2635ca1](https://github.com/AllanOricil/nrg-sentinel/commit/2635ca1d1eaad74daf00c9e4a1686546238d50c8))
* demo 19 — HTTP route deletion via _router.stack reassignment ([f156d41](https://github.com/AllanOricil/nrg-sentinel/commit/f156d4132d9e756aec31042068423c5cd629ac06))
* e2e demo 33 — node event hijack (node:events:on + node:events:remove-listeners) ([fa60e09](https://github.com/AllanOricil/nrg-sentinel/commit/fa60e09a93430cda35caf144c94e19e31c618b48))
* e2e demos 31 (context permissions) and 32 (flows inject) ([33bfd83](https://github.com/AllanOricil/nrg-sentinel/commit/33bfd83b584082ed925e12389cb7d454138b340f))
* header shows icon-only with red glow; sidebar tab badge with tooltip ([c776f1c](https://github.com/AllanOricil/nrg-sentinel/commit/c776f1c86844f61a006b6bbabeb77b37cac297e5))
* intercept deployments for safe deployment review ([c844f61](https://github.com/AllanOricil/nrg-sentinel/commit/c844f612f64c996065bcee3db544fcd8733ca391))
* node proxy improvements — node:events namespace, NODE_METHOD_CAPS, storage API, call chain ([0ef84e5](https://github.com/AllanOricil/nrg-sentinel/commit/0ef84e5e69ffbd40d81468b6fad2d52c16c1c60b))
* redesign header badge and add sidebar tab status badge ([22889b3](https://github.com/AllanOricil/nrg-sentinel/commit/22889b3d1f2ee2338caa91dfe0d1d60d6f2ac033)), closes [#7a0000](https://github.com/AllanOricil/nrg-sentinel/issues/7a0000)
* rename package to @allanoricil/nrg-sentinel, merge package.json, add AGPL-3.0 license ([88a85ae](https://github.com/AllanOricil/nrg-sentinel/commit/88a85ae60871e57b4c222514421cc8c071605c93))
* restrict Sentinel panel to admin users, add test accounts ([e1cf7fe](https://github.com/AllanOricil/nrg-sentinel/commit/e1cf7fe766752403ebdbcf220958ce307bc135b1))
* threat log persistence, call stack in threats, UI improvements ([7a76e7c](https://github.com/AllanOricil/nrg-sentinel/commit/7a76e7c779a4b010e36fd6621443f5d6e9d5382b))

# 1.0.0 (2026-03-17)


### Bug Fixes

* add publishConfig access:public to dist/package.json ([345814b](https://github.com/AllanOricil/nrg-sentinel/commit/345814b8adb21be53e6715b002834b1d14e94899))
* **ci:** deduplicate artifact filenames so all 18 results survive merge ([3d815c6](https://github.com/AllanOricil/nrg-sentinel/commit/3d815c61c734a004a8f0ad10c64bdeb013720c66))
* commit missing @node-red/fake-nodes test fixture ([e24e796](https://github.com/AllanOricil/nrg-sentinel/commit/e24e796d39d78df5c5523fb54475fee864327dfb))
* correct NRG hex icon, glow behind SVG, and sidebar tab badge visibility ([348db51](https://github.com/AllanOricil/nrg-sentinel/commit/348db517d1ed1289a009487b901ae0fa737ab3b1))
* **demo-18:** fix failing deep stack bypass demo ([909b287](https://github.com/AllanOricil/nrg-sentinel/commit/909b287a6f6466d39cf299a424744f70da4a093f))
* detect scoped config nodes via absence of x/y coords, not z==="" ([3737bbe](https://github.com/AllanOricil/nrg-sentinel/commit/3737bbedc0cf43701e334b81b67f36661a60c67e))
* exclude 'unknown' node type from Node Permissions list ([39d4184](https://github.com/AllanOricil/nrg-sentinel/commit/39d418428df2e62f2e1f2be7965a96485382d2df))
* glow via drop-shadow filter on SVG; fix badge nested-<a> bug ([50b6499](https://github.com/AllanOricil/nrg-sentinel/commit/50b64994ed5d2cf9093a15ad1ed4e07b609dc3d1))
* landing page hero columns and copy buttons; improve header badge icon ([f99a0af](https://github.com/AllanOricil/nrg-sentinel/commit/f99a0affefba5f18604179e483623eb37a8b88da))
* let public repo semantic-release own the tag and npm publish ([6e534a5](https://github.com/AllanOricil/nrg-sentinel/commit/6e534a5cfc0aaa55c424dc7d2bd4063244b0d78e))
* make bin wrapper work for both Docker (require.resolve) and userDir (PATH) ([120fc5e](https://github.com/AllanOricil/nrg-sentinel/commit/120fc5e589625748e8f7eeff27dcf6added19c7e))
* pin remaining intrinsics, add copyright headers, fix e2e tests 15 and 18 ([c20fa9a](https://github.com/AllanOricil/nrg-sentinel/commit/c20fa9a14a57c5385db5405864ad99d3c59cd424))
* pin WeakMap intrinsics to prevent prototype tampering ([146e93f](https://github.com/AllanOricil/nrg-sentinel/commit/146e93f7c9c5bca64d16f8e1afd166b92d2fee34))
* read .sentinel-license file on startup; fix license dialog UI ([e0e9b60](https://github.com/AllanOricil/nrg-sentinel/commit/e0e9b600124cccf208f1a6a23dfab1f944149d8e))
* remove z==="" fallback — WeakMap is always populated before proxy creation ([fb93ecb](https://github.com/AllanOricil/nrg-sentinel/commit/fb93ecb7b14d34794b6be103e235fc12ac025e52))
* rename .sentinel-permissions.json → .sentinel-grants.json in docs and tests ([6c5fe6a](https://github.com/AllanOricil/nrg-sentinel/commit/6c5fe6a789418ae6ee887633ed8ce5c8519f7f3f))
* resolve lint errors introduced by safe deployment feature ([0cbf03c](https://github.com/AllanOricil/nrg-sentinel/commit/0cbf03ce86505d0d0650b9d8d1635cf0fe593279))
* resolve node-red via PATH instead of require.resolve in bin wrapper ([6bde060](https://github.com/AllanOricil/nrg-sentinel/commit/6bde060523d64ac1b5dcb25e63a68fbd895f62ee))
* restore contents: read permission lost when actions: read was added ([cce680d](https://github.com/AllanOricil/nrg-sentinel/commit/cce680d8068eb49d713f29fa8f1fbab3ac2d7767))
* scope Run-column strip to E2E block and copy docs/ in sync script ([d8cb96e](https://github.com/AllanOricil/nrg-sentinel/commit/d8cb96e6489bb074b31d061d8e81481c63c81341))
* show trial/expired notification only once per session ([c48fb68](https://github.com/AllanOricil/nrg-sentinel/commit/c48fb68bc7c2be1c2c77286594fe7bf58b778a48))
* sync .github, .releaserc.json and .gitignore to public repo ([9ddc1cb](https://github.com/AllanOricil/nrg-sentinel/commit/9ddc1cb438431f01cbd983725d4cdb047d7c1eec))
* update e2e test 03 and integration test to use .sentinel-grants.json ([167194b](https://github.com/AllanOricil/nrg-sentinel/commit/167194b1f6349615cd88e49921b1242da44ac4d5)), closes [#summary-](https://github.com/AllanOricil/nrg-sentinel/issues/summary-)
* use process.argv[1] in bin/node-red.js to find co-installed node-red ([fd5473d](https://github.com/AllanOricil/nrg-sentinel/commit/fd5473dfe0ff40362ae56bc220df889e7403b5f5))
* use runner.name to resolve job ID for summary anchor ([8a5080e](https://github.com/AllanOricil/nrg-sentinel/commit/8a5080ea23094876c6bfe73c1f1e4ce8f4c2f6b1))


### Features

* add '0 dependencies' stat to landing page hero stats bar ([10d0b9b](https://github.com/AllanOricil/nrg-sentinel/commit/10d0b9bc937124020f13a5913d5270def9c90f50))
* add deployment review UI with visual flow diff ([fd46d9e](https://github.com/AllanOricil/nrg-sentinel/commit/fd46d9ea9b72be1ec6299c1b1fef76802a8c7d74))
* add e2e demo 31 — Context Permissions ([c7a63ac](https://github.com/AllanOricil/nrg-sentinel/commit/c7a63ac08e8a876591ab42909619b999b0b1b3d0))
* add e2e tests 20-30, fix all demo verdicts, strengthen CI ([235d963](https://github.com/AllanOricil/nrg-sentinel/commit/235d9633bf95c5dcd6cd0653ba8cf9467f13071c))
* add pending deployments banner in Sentinel sidebar ([e07ef42](https://github.com/AllanOricil/nrg-sentinel/commit/e07ef42d2089b6d35cabea049b98e75e0f8d87fb))
* add release workflow with semantic-release and build pipeline ([ff38bfe](https://github.com/AllanOricil/nrg-sentinel/commit/ff38bfeaff56de131e902588ad38cab3004d496c))
* add safe deployment queue module ([8917212](https://github.com/AllanOricil/nrg-sentinel/commit/8917212a511215b51f91c8f10b177deb1c6ef96f))
* add structural flow diff engine ([0d52969](https://github.com/AllanOricil/nrg-sentinel/commit/0d52969ae39ce97cf2127608340ce05a1ee4104a))
* add two-repo distribution pipeline, landing page, and licensing docs ([2635ca1](https://github.com/AllanOricil/nrg-sentinel/commit/2635ca1d1eaad74daf00c9e4a1686546238d50c8))
* demo 19 — HTTP route deletion via _router.stack reassignment ([f156d41](https://github.com/AllanOricil/nrg-sentinel/commit/f156d4132d9e756aec31042068423c5cd629ac06))
* e2e demo 33 — node event hijack (node:events:on + node:events:remove-listeners) ([fa60e09](https://github.com/AllanOricil/nrg-sentinel/commit/fa60e09a93430cda35caf144c94e19e31c618b48))
* e2e demos 31 (context permissions) and 32 (flows inject) ([33bfd83](https://github.com/AllanOricil/nrg-sentinel/commit/33bfd83b584082ed925e12389cb7d454138b340f))
* header shows icon-only with red glow; sidebar tab badge with tooltip ([c776f1c](https://github.com/AllanOricil/nrg-sentinel/commit/c776f1c86844f61a006b6bbabeb77b37cac297e5))
* intercept deployments for safe deployment review ([c844f61](https://github.com/AllanOricil/nrg-sentinel/commit/c844f612f64c996065bcee3db544fcd8733ca391))
* node proxy improvements — node:events namespace, NODE_METHOD_CAPS, storage API, call chain ([0ef84e5](https://github.com/AllanOricil/nrg-sentinel/commit/0ef84e5e69ffbd40d81468b6fad2d52c16c1c60b))
* redesign header badge and add sidebar tab status badge ([22889b3](https://github.com/AllanOricil/nrg-sentinel/commit/22889b3d1f2ee2338caa91dfe0d1d60d6f2ac033)), closes [#7a0000](https://github.com/AllanOricil/nrg-sentinel/issues/7a0000)
* rename package to @allanoricil/nrg-sentinel, merge package.json, add AGPL-3.0 license ([88a85ae](https://github.com/AllanOricil/nrg-sentinel/commit/88a85ae60871e57b4c222514421cc8c071605c93))
* restrict Sentinel panel to admin users, add test accounts ([e1cf7fe](https://github.com/AllanOricil/nrg-sentinel/commit/e1cf7fe766752403ebdbcf220958ce307bc135b1))
* threat log persistence, call stack in threats, UI improvements ([7a76e7c](https://github.com/AllanOricil/nrg-sentinel/commit/7a76e7c779a4b010e36fd6621443f5d6e9d5382b))

# 1.0.0 (2026-03-17)


### Bug Fixes

* **ci:** deduplicate artifact filenames so all 18 results survive merge ([3d815c6](https://github.com/AllanOricil/nrg-sentinel/commit/3d815c61c734a004a8f0ad10c64bdeb013720c66))
* commit missing @node-red/fake-nodes test fixture ([e24e796](https://github.com/AllanOricil/nrg-sentinel/commit/e24e796d39d78df5c5523fb54475fee864327dfb))
* correct NRG hex icon, glow behind SVG, and sidebar tab badge visibility ([348db51](https://github.com/AllanOricil/nrg-sentinel/commit/348db517d1ed1289a009487b901ae0fa737ab3b1))
* **demo-18:** fix failing deep stack bypass demo ([909b287](https://github.com/AllanOricil/nrg-sentinel/commit/909b287a6f6466d39cf299a424744f70da4a093f))
* detect scoped config nodes via absence of x/y coords, not z==="" ([3737bbe](https://github.com/AllanOricil/nrg-sentinel/commit/3737bbedc0cf43701e334b81b67f36661a60c67e))
* exclude 'unknown' node type from Node Permissions list ([39d4184](https://github.com/AllanOricil/nrg-sentinel/commit/39d418428df2e62f2e1f2be7965a96485382d2df))
* glow via drop-shadow filter on SVG; fix badge nested-<a> bug ([50b6499](https://github.com/AllanOricil/nrg-sentinel/commit/50b64994ed5d2cf9093a15ad1ed4e07b609dc3d1))
* landing page hero columns and copy buttons; improve header badge icon ([f99a0af](https://github.com/AllanOricil/nrg-sentinel/commit/f99a0affefba5f18604179e483623eb37a8b88da))
* let public repo semantic-release own the tag and npm publish ([6e534a5](https://github.com/AllanOricil/nrg-sentinel/commit/6e534a5cfc0aaa55c424dc7d2bd4063244b0d78e))
* make bin wrapper work for both Docker (require.resolve) and userDir (PATH) ([120fc5e](https://github.com/AllanOricil/nrg-sentinel/commit/120fc5e589625748e8f7eeff27dcf6added19c7e))
* pin remaining intrinsics, add copyright headers, fix e2e tests 15 and 18 ([c20fa9a](https://github.com/AllanOricil/nrg-sentinel/commit/c20fa9a14a57c5385db5405864ad99d3c59cd424))
* pin WeakMap intrinsics to prevent prototype tampering ([146e93f](https://github.com/AllanOricil/nrg-sentinel/commit/146e93f7c9c5bca64d16f8e1afd166b92d2fee34))
* read .sentinel-license file on startup; fix license dialog UI ([e0e9b60](https://github.com/AllanOricil/nrg-sentinel/commit/e0e9b600124cccf208f1a6a23dfab1f944149d8e))
* remove z==="" fallback — WeakMap is always populated before proxy creation ([fb93ecb](https://github.com/AllanOricil/nrg-sentinel/commit/fb93ecb7b14d34794b6be103e235fc12ac025e52))
* rename .sentinel-permissions.json → .sentinel-grants.json in docs and tests ([6c5fe6a](https://github.com/AllanOricil/nrg-sentinel/commit/6c5fe6a789418ae6ee887633ed8ce5c8519f7f3f))
* resolve lint errors introduced by safe deployment feature ([0cbf03c](https://github.com/AllanOricil/nrg-sentinel/commit/0cbf03ce86505d0d0650b9d8d1635cf0fe593279))
* resolve node-red via PATH instead of require.resolve in bin wrapper ([6bde060](https://github.com/AllanOricil/nrg-sentinel/commit/6bde060523d64ac1b5dcb25e63a68fbd895f62ee))
* restore contents: read permission lost when actions: read was added ([cce680d](https://github.com/AllanOricil/nrg-sentinel/commit/cce680d8068eb49d713f29fa8f1fbab3ac2d7767))
* scope Run-column strip to E2E block and copy docs/ in sync script ([d8cb96e](https://github.com/AllanOricil/nrg-sentinel/commit/d8cb96e6489bb074b31d061d8e81481c63c81341))
* show trial/expired notification only once per session ([c48fb68](https://github.com/AllanOricil/nrg-sentinel/commit/c48fb68bc7c2be1c2c77286594fe7bf58b778a48))
* sync .github, .releaserc.json and .gitignore to public repo ([9ddc1cb](https://github.com/AllanOricil/nrg-sentinel/commit/9ddc1cb438431f01cbd983725d4cdb047d7c1eec))
* update e2e test 03 and integration test to use .sentinel-grants.json ([167194b](https://github.com/AllanOricil/nrg-sentinel/commit/167194b1f6349615cd88e49921b1242da44ac4d5)), closes [#summary-](https://github.com/AllanOricil/nrg-sentinel/issues/summary-)
* use process.argv[1] in bin/node-red.js to find co-installed node-red ([fd5473d](https://github.com/AllanOricil/nrg-sentinel/commit/fd5473dfe0ff40362ae56bc220df889e7403b5f5))
* use runner.name to resolve job ID for summary anchor ([8a5080e](https://github.com/AllanOricil/nrg-sentinel/commit/8a5080ea23094876c6bfe73c1f1e4ce8f4c2f6b1))


### Features

* add '0 dependencies' stat to landing page hero stats bar ([10d0b9b](https://github.com/AllanOricil/nrg-sentinel/commit/10d0b9bc937124020f13a5913d5270def9c90f50))
* add deployment review UI with visual flow diff ([fd46d9e](https://github.com/AllanOricil/nrg-sentinel/commit/fd46d9ea9b72be1ec6299c1b1fef76802a8c7d74))
* add e2e demo 31 — Context Permissions ([c7a63ac](https://github.com/AllanOricil/nrg-sentinel/commit/c7a63ac08e8a876591ab42909619b999b0b1b3d0))
* add e2e tests 20-30, fix all demo verdicts, strengthen CI ([235d963](https://github.com/AllanOricil/nrg-sentinel/commit/235d9633bf95c5dcd6cd0653ba8cf9467f13071c))
* add pending deployments banner in Sentinel sidebar ([e07ef42](https://github.com/AllanOricil/nrg-sentinel/commit/e07ef42d2089b6d35cabea049b98e75e0f8d87fb))
* add release workflow with semantic-release and build pipeline ([ff38bfe](https://github.com/AllanOricil/nrg-sentinel/commit/ff38bfeaff56de131e902588ad38cab3004d496c))
* add safe deployment queue module ([8917212](https://github.com/AllanOricil/nrg-sentinel/commit/8917212a511215b51f91c8f10b177deb1c6ef96f))
* add structural flow diff engine ([0d52969](https://github.com/AllanOricil/nrg-sentinel/commit/0d52969ae39ce97cf2127608340ce05a1ee4104a))
* add two-repo distribution pipeline, landing page, and licensing docs ([2635ca1](https://github.com/AllanOricil/nrg-sentinel/commit/2635ca1d1eaad74daf00c9e4a1686546238d50c8))
* demo 19 — HTTP route deletion via _router.stack reassignment ([f156d41](https://github.com/AllanOricil/nrg-sentinel/commit/f156d4132d9e756aec31042068423c5cd629ac06))
* e2e demo 33 — node event hijack (node:events:on + node:events:remove-listeners) ([fa60e09](https://github.com/AllanOricil/nrg-sentinel/commit/fa60e09a93430cda35caf144c94e19e31c618b48))
* e2e demos 31 (context permissions) and 32 (flows inject) ([33bfd83](https://github.com/AllanOricil/nrg-sentinel/commit/33bfd83b584082ed925e12389cb7d454138b340f))
* header shows icon-only with red glow; sidebar tab badge with tooltip ([c776f1c](https://github.com/AllanOricil/nrg-sentinel/commit/c776f1c86844f61a006b6bbabeb77b37cac297e5))
* intercept deployments for safe deployment review ([c844f61](https://github.com/AllanOricil/nrg-sentinel/commit/c844f612f64c996065bcee3db544fcd8733ca391))
* node proxy improvements — node:events namespace, NODE_METHOD_CAPS, storage API, call chain ([0ef84e5](https://github.com/AllanOricil/nrg-sentinel/commit/0ef84e5e69ffbd40d81468b6fad2d52c16c1c60b))
* redesign header badge and add sidebar tab status badge ([22889b3](https://github.com/AllanOricil/nrg-sentinel/commit/22889b3d1f2ee2338caa91dfe0d1d60d6f2ac033)), closes [#7a0000](https://github.com/AllanOricil/nrg-sentinel/issues/7a0000)
* rename package to @allanoricil/nrg-sentinel, merge package.json, add AGPL-3.0 license ([88a85ae](https://github.com/AllanOricil/nrg-sentinel/commit/88a85ae60871e57b4c222514421cc8c071605c93))
* restrict Sentinel panel to admin users, add test accounts ([e1cf7fe](https://github.com/AllanOricil/nrg-sentinel/commit/e1cf7fe766752403ebdbcf220958ce307bc135b1))
* threat log persistence, call stack in threats, UI improvements ([7a76e7c](https://github.com/AllanOricil/nrg-sentinel/commit/7a76e7c779a4b010e36fd6621443f5d6e9d5382b))

# 1.0.0 (2026-03-17)


### Bug Fixes

* **ci:** deduplicate artifact filenames so all 18 results survive merge ([3d815c6](https://github.com/AllanOricil/nrg-sentinel/commit/3d815c61c734a004a8f0ad10c64bdeb013720c66))
* commit missing @node-red/fake-nodes test fixture ([e24e796](https://github.com/AllanOricil/nrg-sentinel/commit/e24e796d39d78df5c5523fb54475fee864327dfb))
* correct NRG hex icon, glow behind SVG, and sidebar tab badge visibility ([348db51](https://github.com/AllanOricil/nrg-sentinel/commit/348db517d1ed1289a009487b901ae0fa737ab3b1))
* **demo-18:** fix failing deep stack bypass demo ([909b287](https://github.com/AllanOricil/nrg-sentinel/commit/909b287a6f6466d39cf299a424744f70da4a093f))
* detect scoped config nodes via absence of x/y coords, not z==="" ([3737bbe](https://github.com/AllanOricil/nrg-sentinel/commit/3737bbedc0cf43701e334b81b67f36661a60c67e))
* exclude 'unknown' node type from Node Permissions list ([39d4184](https://github.com/AllanOricil/nrg-sentinel/commit/39d418428df2e62f2e1f2be7965a96485382d2df))
* glow via drop-shadow filter on SVG; fix badge nested-<a> bug ([50b6499](https://github.com/AllanOricil/nrg-sentinel/commit/50b64994ed5d2cf9093a15ad1ed4e07b609dc3d1))
* landing page hero columns and copy buttons; improve header badge icon ([f99a0af](https://github.com/AllanOricil/nrg-sentinel/commit/f99a0affefba5f18604179e483623eb37a8b88da))
* make bin wrapper work for both Docker (require.resolve) and userDir (PATH) ([120fc5e](https://github.com/AllanOricil/nrg-sentinel/commit/120fc5e589625748e8f7eeff27dcf6added19c7e))
* pin remaining intrinsics, add copyright headers, fix e2e tests 15 and 18 ([c20fa9a](https://github.com/AllanOricil/nrg-sentinel/commit/c20fa9a14a57c5385db5405864ad99d3c59cd424))
* pin WeakMap intrinsics to prevent prototype tampering ([146e93f](https://github.com/AllanOricil/nrg-sentinel/commit/146e93f7c9c5bca64d16f8e1afd166b92d2fee34))
* read .sentinel-license file on startup; fix license dialog UI ([e0e9b60](https://github.com/AllanOricil/nrg-sentinel/commit/e0e9b600124cccf208f1a6a23dfab1f944149d8e))
* remove z==="" fallback — WeakMap is always populated before proxy creation ([fb93ecb](https://github.com/AllanOricil/nrg-sentinel/commit/fb93ecb7b14d34794b6be103e235fc12ac025e52))
* rename .sentinel-permissions.json → .sentinel-grants.json in docs and tests ([6c5fe6a](https://github.com/AllanOricil/nrg-sentinel/commit/6c5fe6a789418ae6ee887633ed8ce5c8519f7f3f))
* resolve lint errors introduced by safe deployment feature ([0cbf03c](https://github.com/AllanOricil/nrg-sentinel/commit/0cbf03ce86505d0d0650b9d8d1635cf0fe593279))
* resolve node-red via PATH instead of require.resolve in bin wrapper ([6bde060](https://github.com/AllanOricil/nrg-sentinel/commit/6bde060523d64ac1b5dcb25e63a68fbd895f62ee))
* restore contents: read permission lost when actions: read was added ([cce680d](https://github.com/AllanOricil/nrg-sentinel/commit/cce680d8068eb49d713f29fa8f1fbab3ac2d7767))
* scope Run-column strip to E2E block and copy docs/ in sync script ([d8cb96e](https://github.com/AllanOricil/nrg-sentinel/commit/d8cb96e6489bb074b31d061d8e81481c63c81341))
* show trial/expired notification only once per session ([c48fb68](https://github.com/AllanOricil/nrg-sentinel/commit/c48fb68bc7c2be1c2c77286594fe7bf58b778a48))
* update e2e test 03 and integration test to use .sentinel-grants.json ([167194b](https://github.com/AllanOricil/nrg-sentinel/commit/167194b1f6349615cd88e49921b1242da44ac4d5)), closes [#summary-](https://github.com/AllanOricil/nrg-sentinel/issues/summary-)
* use process.argv[1] in bin/node-red.js to find co-installed node-red ([fd5473d](https://github.com/AllanOricil/nrg-sentinel/commit/fd5473dfe0ff40362ae56bc220df889e7403b5f5))
* use runner.name to resolve job ID for summary anchor ([8a5080e](https://github.com/AllanOricil/nrg-sentinel/commit/8a5080ea23094876c6bfe73c1f1e4ce8f4c2f6b1))


### Features

* add '0 dependencies' stat to landing page hero stats bar ([10d0b9b](https://github.com/AllanOricil/nrg-sentinel/commit/10d0b9bc937124020f13a5913d5270def9c90f50))
* add deployment review UI with visual flow diff ([fd46d9e](https://github.com/AllanOricil/nrg-sentinel/commit/fd46d9ea9b72be1ec6299c1b1fef76802a8c7d74))
* add e2e demo 31 — Context Permissions ([c7a63ac](https://github.com/AllanOricil/nrg-sentinel/commit/c7a63ac08e8a876591ab42909619b999b0b1b3d0))
* add e2e tests 20-30, fix all demo verdicts, strengthen CI ([235d963](https://github.com/AllanOricil/nrg-sentinel/commit/235d9633bf95c5dcd6cd0653ba8cf9467f13071c))
* add pending deployments banner in Sentinel sidebar ([e07ef42](https://github.com/AllanOricil/nrg-sentinel/commit/e07ef42d2089b6d35cabea049b98e75e0f8d87fb))
* add release workflow with semantic-release and build pipeline ([ff38bfe](https://github.com/AllanOricil/nrg-sentinel/commit/ff38bfeaff56de131e902588ad38cab3004d496c))
* add safe deployment queue module ([8917212](https://github.com/AllanOricil/nrg-sentinel/commit/8917212a511215b51f91c8f10b177deb1c6ef96f))
* add structural flow diff engine ([0d52969](https://github.com/AllanOricil/nrg-sentinel/commit/0d52969ae39ce97cf2127608340ce05a1ee4104a))
* add two-repo distribution pipeline, landing page, and licensing docs ([2635ca1](https://github.com/AllanOricil/nrg-sentinel/commit/2635ca1d1eaad74daf00c9e4a1686546238d50c8))
* demo 19 — HTTP route deletion via _router.stack reassignment ([f156d41](https://github.com/AllanOricil/nrg-sentinel/commit/f156d4132d9e756aec31042068423c5cd629ac06))
* e2e demo 33 — node event hijack (node:events:on + node:events:remove-listeners) ([fa60e09](https://github.com/AllanOricil/nrg-sentinel/commit/fa60e09a93430cda35caf144c94e19e31c618b48))
* e2e demos 31 (context permissions) and 32 (flows inject) ([33bfd83](https://github.com/AllanOricil/nrg-sentinel/commit/33bfd83b584082ed925e12389cb7d454138b340f))
* header shows icon-only with red glow; sidebar tab badge with tooltip ([c776f1c](https://github.com/AllanOricil/nrg-sentinel/commit/c776f1c86844f61a006b6bbabeb77b37cac297e5))
* intercept deployments for safe deployment review ([c844f61](https://github.com/AllanOricil/nrg-sentinel/commit/c844f612f64c996065bcee3db544fcd8733ca391))
* node proxy improvements — node:events namespace, NODE_METHOD_CAPS, storage API, call chain ([0ef84e5](https://github.com/AllanOricil/nrg-sentinel/commit/0ef84e5e69ffbd40d81468b6fad2d52c16c1c60b))
* redesign header badge and add sidebar tab status badge ([22889b3](https://github.com/AllanOricil/nrg-sentinel/commit/22889b3d1f2ee2338caa91dfe0d1d60d6f2ac033)), closes [#7a0000](https://github.com/AllanOricil/nrg-sentinel/issues/7a0000)
* rename package to @allanoricil/nrg-sentinel, merge package.json, add AGPL-3.0 license ([88a85ae](https://github.com/AllanOricil/nrg-sentinel/commit/88a85ae60871e57b4c222514421cc8c071605c93))
* restrict Sentinel panel to admin users, add test accounts ([e1cf7fe](https://github.com/AllanOricil/nrg-sentinel/commit/e1cf7fe766752403ebdbcf220958ce307bc135b1))
* threat log persistence, call stack in threats, UI improvements ([7a76e7c](https://github.com/AllanOricil/nrg-sentinel/commit/7a76e7c779a4b010e36fd6621443f5d6e9d5382b))

# 1.0.0 (2026-03-17)


### Bug Fixes

* **ci:** deduplicate artifact filenames so all 18 results survive merge ([3d815c6](https://github.com/AllanOricil/nrg-sentinel/commit/3d815c61c734a004a8f0ad10c64bdeb013720c66))
* commit missing @node-red/fake-nodes test fixture ([e24e796](https://github.com/AllanOricil/nrg-sentinel/commit/e24e796d39d78df5c5523fb54475fee864327dfb))
* correct NRG hex icon, glow behind SVG, and sidebar tab badge visibility ([348db51](https://github.com/AllanOricil/nrg-sentinel/commit/348db517d1ed1289a009487b901ae0fa737ab3b1))
* **demo-18:** fix failing deep stack bypass demo ([909b287](https://github.com/AllanOricil/nrg-sentinel/commit/909b287a6f6466d39cf299a424744f70da4a093f))
* detect scoped config nodes via absence of x/y coords, not z==="" ([3737bbe](https://github.com/AllanOricil/nrg-sentinel/commit/3737bbedc0cf43701e334b81b67f36661a60c67e))
* exclude 'unknown' node type from Node Permissions list ([39d4184](https://github.com/AllanOricil/nrg-sentinel/commit/39d418428df2e62f2e1f2be7965a96485382d2df))
* glow via drop-shadow filter on SVG; fix badge nested-<a> bug ([50b6499](https://github.com/AllanOricil/nrg-sentinel/commit/50b64994ed5d2cf9093a15ad1ed4e07b609dc3d1))
* landing page hero columns and copy buttons; improve header badge icon ([f99a0af](https://github.com/AllanOricil/nrg-sentinel/commit/f99a0affefba5f18604179e483623eb37a8b88da))
* make bin wrapper work for both Docker (require.resolve) and userDir (PATH) ([120fc5e](https://github.com/AllanOricil/nrg-sentinel/commit/120fc5e589625748e8f7eeff27dcf6added19c7e))
* pin remaining intrinsics, add copyright headers, fix e2e tests 15 and 18 ([c20fa9a](https://github.com/AllanOricil/nrg-sentinel/commit/c20fa9a14a57c5385db5405864ad99d3c59cd424))
* pin WeakMap intrinsics to prevent prototype tampering ([146e93f](https://github.com/AllanOricil/nrg-sentinel/commit/146e93f7c9c5bca64d16f8e1afd166b92d2fee34))
* read .sentinel-license file on startup; fix license dialog UI ([e0e9b60](https://github.com/AllanOricil/nrg-sentinel/commit/e0e9b600124cccf208f1a6a23dfab1f944149d8e))
* remove z==="" fallback — WeakMap is always populated before proxy creation ([fb93ecb](https://github.com/AllanOricil/nrg-sentinel/commit/fb93ecb7b14d34794b6be103e235fc12ac025e52))
* rename .sentinel-permissions.json → .sentinel-grants.json in docs and tests ([6c5fe6a](https://github.com/AllanOricil/nrg-sentinel/commit/6c5fe6a789418ae6ee887633ed8ce5c8519f7f3f))
* resolve lint errors introduced by safe deployment feature ([0cbf03c](https://github.com/AllanOricil/nrg-sentinel/commit/0cbf03ce86505d0d0650b9d8d1635cf0fe593279))
* resolve node-red via PATH instead of require.resolve in bin wrapper ([6bde060](https://github.com/AllanOricil/nrg-sentinel/commit/6bde060523d64ac1b5dcb25e63a68fbd895f62ee))
* restore contents: read permission lost when actions: read was added ([cce680d](https://github.com/AllanOricil/nrg-sentinel/commit/cce680d8068eb49d713f29fa8f1fbab3ac2d7767))
* show trial/expired notification only once per session ([c48fb68](https://github.com/AllanOricil/nrg-sentinel/commit/c48fb68bc7c2be1c2c77286594fe7bf58b778a48))
* update e2e test 03 and integration test to use .sentinel-grants.json ([167194b](https://github.com/AllanOricil/nrg-sentinel/commit/167194b1f6349615cd88e49921b1242da44ac4d5)), closes [#summary-](https://github.com/AllanOricil/nrg-sentinel/issues/summary-)
* use process.argv[1] in bin/node-red.js to find co-installed node-red ([fd5473d](https://github.com/AllanOricil/nrg-sentinel/commit/fd5473dfe0ff40362ae56bc220df889e7403b5f5))
* use runner.name to resolve job ID for summary anchor ([8a5080e](https://github.com/AllanOricil/nrg-sentinel/commit/8a5080ea23094876c6bfe73c1f1e4ce8f4c2f6b1))


### Features

* add '0 dependencies' stat to landing page hero stats bar ([10d0b9b](https://github.com/AllanOricil/nrg-sentinel/commit/10d0b9bc937124020f13a5913d5270def9c90f50))
* add deployment review UI with visual flow diff ([fd46d9e](https://github.com/AllanOricil/nrg-sentinel/commit/fd46d9ea9b72be1ec6299c1b1fef76802a8c7d74))
* add e2e demo 31 — Context Permissions ([c7a63ac](https://github.com/AllanOricil/nrg-sentinel/commit/c7a63ac08e8a876591ab42909619b999b0b1b3d0))
* add e2e tests 20-30, fix all demo verdicts, strengthen CI ([235d963](https://github.com/AllanOricil/nrg-sentinel/commit/235d9633bf95c5dcd6cd0653ba8cf9467f13071c))
* add pending deployments banner in Sentinel sidebar ([e07ef42](https://github.com/AllanOricil/nrg-sentinel/commit/e07ef42d2089b6d35cabea049b98e75e0f8d87fb))
* add release workflow with semantic-release and build pipeline ([ff38bfe](https://github.com/AllanOricil/nrg-sentinel/commit/ff38bfeaff56de131e902588ad38cab3004d496c))
* add safe deployment queue module ([8917212](https://github.com/AllanOricil/nrg-sentinel/commit/8917212a511215b51f91c8f10b177deb1c6ef96f))
* add structural flow diff engine ([0d52969](https://github.com/AllanOricil/nrg-sentinel/commit/0d52969ae39ce97cf2127608340ce05a1ee4104a))
* add two-repo distribution pipeline, landing page, and licensing docs ([2635ca1](https://github.com/AllanOricil/nrg-sentinel/commit/2635ca1d1eaad74daf00c9e4a1686546238d50c8))
* demo 19 — HTTP route deletion via _router.stack reassignment ([f156d41](https://github.com/AllanOricil/nrg-sentinel/commit/f156d4132d9e756aec31042068423c5cd629ac06))
* e2e demo 33 — node event hijack (node:events:on + node:events:remove-listeners) ([fa60e09](https://github.com/AllanOricil/nrg-sentinel/commit/fa60e09a93430cda35caf144c94e19e31c618b48))
* e2e demos 31 (context permissions) and 32 (flows inject) ([33bfd83](https://github.com/AllanOricil/nrg-sentinel/commit/33bfd83b584082ed925e12389cb7d454138b340f))
* header shows icon-only with red glow; sidebar tab badge with tooltip ([c776f1c](https://github.com/AllanOricil/nrg-sentinel/commit/c776f1c86844f61a006b6bbabeb77b37cac297e5))
* intercept deployments for safe deployment review ([c844f61](https://github.com/AllanOricil/nrg-sentinel/commit/c844f612f64c996065bcee3db544fcd8733ca391))
* node proxy improvements — node:events namespace, NODE_METHOD_CAPS, storage API, call chain ([0ef84e5](https://github.com/AllanOricil/nrg-sentinel/commit/0ef84e5e69ffbd40d81468b6fad2d52c16c1c60b))
* redesign header badge and add sidebar tab status badge ([22889b3](https://github.com/AllanOricil/nrg-sentinel/commit/22889b3d1f2ee2338caa91dfe0d1d60d6f2ac033)), closes [#7a0000](https://github.com/AllanOricil/nrg-sentinel/issues/7a0000)
* rename package to @allanoricil/nrg-sentinel, merge package.json, add AGPL-3.0 license ([88a85ae](https://github.com/AllanOricil/nrg-sentinel/commit/88a85ae60871e57b4c222514421cc8c071605c93))
* restrict Sentinel panel to admin users, add test accounts ([e1cf7fe](https://github.com/AllanOricil/nrg-sentinel/commit/e1cf7fe766752403ebdbcf220958ce307bc135b1))
* threat log persistence, call stack in threats, UI improvements ([7a76e7c](https://github.com/AllanOricil/nrg-sentinel/commit/7a76e7c779a4b010e36fd6621443f5d6e9d5382b))

# 1.0.0 (2026-03-10)


### Bug Fixes

* **ci:** deduplicate artifact filenames so all 18 results survive merge ([3d815c6](https://github.com/AllanOricil/nrg-sentinel/commit/3d815c61c734a004a8f0ad10c64bdeb013720c66))
* **demo-18:** fix failing deep stack bypass demo ([909b287](https://github.com/AllanOricil/nrg-sentinel/commit/909b287a6f6466d39cf299a424744f70da4a093f))
* restore contents: read permission lost when actions: read was added ([cce680d](https://github.com/AllanOricil/nrg-sentinel/commit/cce680d8068eb49d713f29fa8f1fbab3ac2d7767))
* use runner.name to resolve job ID for summary anchor ([8a5080e](https://github.com/AllanOricil/nrg-sentinel/commit/8a5080ea23094876c6bfe73c1f1e4ce8f4c2f6b1))


### Features

* add release workflow with semantic-release and build pipeline ([ff38bfe](https://github.com/AllanOricil/nrg-sentinel/commit/ff38bfeaff56de131e902588ad38cab3004d496c))
* demo 19 — HTTP route deletion via _router.stack reassignment ([f156d41](https://github.com/AllanOricil/nrg-sentinel/commit/f156d4132d9e756aec31042068423c5cd629ac06))
* rename package to @allanoricil/nrg-sentinel, merge package.json, add AGPL-3.0 license ([88a85ae](https://github.com/AllanOricil/nrg-sentinel/commit/88a85ae60871e57b4c222514421cc8c071605c93))
