# Reality OS — Architecture A notes (2026-09-06)

Canonical file: `/workspace/reality_os.py` (full Reality Bridge + Architecture A).  
Slim preserved as: `/workspace/reality_os_slim_2026-09-06.py`.  
Prior full Bridge backup retained: `/workspace/reality_os_backup_2026-09-05.py`.

## What Architecture A adds

- **DualEntropyGate** — before bridge pulse / Oracle commit for REAL actions, requires fresh entropy from **(ANU or AQN)** *and* **NIST Beacon 2.0** (within timeout). If only CSPRNG is available → `degraded=True`, `layer=REAL_DEGRADED` (never pretends full REAL).
- **Fleet seats** — documented physical seats: **G1 S25**, **G2 Tab SM-X230**, **G3 A16 SM-A166P**. Online counts included on mesh heartbeats, `--fleet-status`, and bridge / Oracle payloads.
- **Oracle enrichment** — each bridge-pulse chronicle entry includes: `identity_seed` (+ hash), `nist_pulse_index`, `entropy_sources`, `mesh_seats_online`, `fleet_seats_online`, `degraded`, `timestamp`, `layer`.
- **PhononManifold** — PT-symmetric 2×2 EP (ported from slim); status line on bridge render.
- **Banner** — `Architecture A · Dual Entropy · Oracle · Fleet · 2026-09-06`.

Identity seed: `7f4b2c9a1d5e3f8b6c0a9d1e4f7b2c6d`.

## How to run

```bash
cd /workspace

# One dashboard frame
python reality_os.py --once

# Architecture A bridge pulse (dual-entropy default)
python reality_os.py --bridge

# Explicit Arch A flag (also implied by --bridge)
python reality_os.py --arch-a --bridge

# Fleet seat online summary (G1/G2/G3)
python reality_os.py --fleet-status

# Fleet + bridge together
python reality_os.py --fleet-status --bridge

# Mesh hub (bind 0.0.0.0) / web dashboard
python reality_os.py --mesh --port 8080
python reality_os.py --web --port 8080

# Worker join (existing mesh flags)
python reality_os.py --worker --join http://HUB:8080 --token TOKEN --role 3

# Interactive menu (default)
python reality_os.py
```

Optional env:

- `REALITY_OS_AQN_KEY` — ANU Quantum Numbers API key (preferred QRNG).
- `REALITY_OS_TOKEN` — mesh join token override.

## Tests

```bash
python /workspace/test_reality_os_arch_a.py
```

Offline / mocked network. Asserts DualEntropyGate, Oracle enrichment fields, fleet seats, PhononManifold, CLI flags. Network-dependent QRNG/NIST live fetches are mocked; live `--bridge` may still show `REAL_DEGRADED` when ANU/AQN or NIST are unreachable — that is intentional honesty.

## Notes

- Dual-entropy is the **default** for `--bridge` / bridge pulse key `B`.
- Do not delete backup / slim files.

## 2026-09-06 evening — Improve Reality OS routine

- **Wealth Infinity fix**: `WEALTH_HARD_CAP = 1e15`; `WealthManifold` + `StateStore.load` sanitize non-finite / oversized MYTH wealth so charts and `:,` formatting stay alive.
- **Dashboard honesty**: web `apply()` now shows `REAL` vs `REAL_DEGRADED`, fleet G1–G3 counts, entropy source list, phonon γ; wrapped in try/catch; money formatter handles huge/non-finite values.
- Web dashboard restarted on `127.0.0.1:8080`.

## 2026-09-07 — ANU rate-limit harden

- **ANU last-good cache** (`_anu_cache_data` / `_anu_cache_t`, TTL ~90s): on rate-limit/fail, return cache with label `ANU` / `ANU-legacy` so DualEntropyGate can stay `qrng_ok` without pretending CSPRNG+NIST is full REAL.
- **`_http_json`**: HTTPError now includes response body (detects ANU “1 requests per minute”).
- **No 61s sleep in gate path**; prefetch may one-shot sleep+retry when cache cold. `DUAL_ENTROPY_TIMEOUT_S` → 5.0.
- Still no invented AQN keys; NIST-only / CSPRNG remains `REAL_DEGRADED`.
