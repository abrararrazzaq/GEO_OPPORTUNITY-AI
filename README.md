# GeoOpportunity AI

GeoOpportunity AI is a deterministic, screening-only tool for comparing business categories and locations. It keeps the existing score `S`, indicator weights, hard constraints, and data-readiness score `Q` separate. Every default seed feature is synthetic and marked `illustrative_synthetic`; no synthetic count represents measured Semarang conditions.

## D1–D6 delivery status

| Milestone | Status | Delivered |
|---|---|---|
| D1 — dataset registry | Partial | License-gated manifest import, provenance/checksums, OSM/Overture/building/road/facility/boundary/BPS/land-cover/population/survey templates, and synthetic context fixtures. Local POI and transport inventories still need licensed input. |
| D2 — audit and Q | Partial | AOI coverage grid, completeness, deduplication/source overlap, flags, separate Q, sampling plan, consented-record quality estimates, and audit page. External validation samples are not loaded. |
| D3 — population and competitors | Partial | Population, canonical POI, reach buffer, filter, count and distance APIs. The included POIs are synthetic; they do not describe actual nearby businesses. |
| D4 — market context | Partial | Facility, building-density, hazard-status, market-potential and radius-sensitivity workflows. Default context features are synthetic or unknown. |
| D5 — feasibility and business fit | Partial | Per-factor checklist and YAML-driven category profiles with sensitivity. No combined feasibility verdict is generated. |
| D6 — reports and hardening | Partial | PDF/GeoJSON/GeoPackage include saved insights; docs and E2E flows are maintained. See the verification report for exact checks and remaining runtime gaps. |

More sources improve an analysis only when their license, coverage, attributes, release, and agreement are checked. Missing data stays `insufficient_data` or `unknown`; a low count never establishes that no businesses are present.

## Start locally (PowerShell)

Requirements: Python 3.11+, Node.js 20+, and npm. Docker is optional for local SQLite development.

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -e ".[dev,geospatial]"
alembic upgrade head
python -m app.seed.generate
.\run-server.ps1
```

The API starts on `http://127.0.0.1:8001`. `run-server.ps1` runs migrations before starting Uvicorn. In a second terminal:

```powershell
cd frontend
npm install
npm run dev
```

Open `http://localhost:3000`. The app does not require an AI key. Its interactive basemap uses OpenStreetMap raster tiles and requires internet access; analysis overlays come from the local API. A map attribution is shown in the UI.

Use the analysis menu to start Mode A or Mode B, confirm the plan, select a candidate, and open the market, development checklist, business-fit, sensitivity, and data-audit views. Reports are generated from the saved run and include any saved market, feasibility, and business-fit insights.

## Dataset catalog and current local state

| Source | Current status | Default-analysis behavior |
|---|---|---|
| Synthetic POIs, facilities, buildings, roads and unknown hazards/zoning | `illustrative_synthetic`; fictitious labels | Available for UI and deterministic fixtures only; always visibly labeled synthetic. |
| OpenStreetMap POIs, roads, buildings, facilities and boundaries | Template supplied; no local inventory is bundled | Excluded until an exact extract, checksum, attribution and reviewed license are recorded. |
| Overture Places | Template supplied; no local inventory is bundled | Require release and per-source license review; retain provider source IDs and attribution. |
| WorldPop population raster | Local 2023 modeled estimate may be present; release is an alpha product | Can be selected only when the manifest/license record is approved; remains modeled and year-specific. |
| BPS area tables | Local tables may be present; publication and terms need review | Restricted or pending-review records are excluded from default aggregation. Verification must cite the exact publication. |
| RBI administrative boundaries | A local 2022 extract may be present | Use for area selection only while its release and terms remain unverified; do not treat as a verified authority boundary. |
| ESA WorldCover | Manifest template only | Not loaded by default. Land-cover classes require official release, attribution and coverage checks. |
| RDTR, flood hazards and terrain | Templates or explicit unknown status | Unknown until an official open source, current release, license and site-level reference are documented. |
| User-supplied survey | CSV template | Separate, consent-gated and restricted; personal identifiers and unmapped columns are dropped. Never merged silently with open data. |

No real competitor inventory, local hazard result, or business activity count is included in the synthetic seed. Existing local files under `data/raw/` are ignored by Git and may have different license/verification states; inspect their manifest and catalog record before using them.

In this workspace, raw files are already present for BPS 2025 district population, RBI 2022 administrative boundaries, DISTARU land use/roads/RTRW, and a WorldPop 2023 raster. These are local-only inputs and are not automatically trusted or included in Git. The DISTARU roads GeoJSON currently contains one feature, so it must not be treated as a road network. Verify each source URL, reuse terms, release, checksum, coverage and geometry before importing; keep it excluded or `unknown` while any check is pending.

## Load a Semarang Utara dataset

All downloads and derived files belong in the ignored `data/raw/` folder. The importer reads local files only; it does not fetch data from `source_url`. Keep the original download, record its release and checksum, and do not add the raw file to a commit.

1. **Copy the right manifest template** from `data/manifests/` and record provider, direct source URL, license text, attribution, access date, release/version, valid time, CRS, spatial resolution, completeness method, and processing history. For a real source, keep `data_mode: real_unverified` until both license review and verification evidence are recorded.
2. **OpenStreetMap POIs, roads, buildings, facilities or boundaries:** obtain a Semarang extract from an OSM data provider. Record ODbL and `© OpenStreetMap contributors`. In QGIS or an OSM conversion tool, select only the needed theme and export valid GeoJSON in EPSG:4326 to `data/raw/`. Fill the matching `osm-*.example.yaml` template and explicit field mapping. Inspect local tag coverage before interpreting counts.
3. **Overture Places:** select an exact dated release and inspect each feature's source/license metadata using the official release documentation. Filter to a permitted source/license subset, retain source IDs and attribution, convert the subset to GeoJSON, and fill `overture-places.example.yaml`. Do not treat the theme name as proof that every source in a release has identical terms.
4. **Buildings and land cover:** OSM buildings use the OSM template. ESA WorldCover requires the release-specific year/version, CC BY 4.0 attribution and tile coverage fields in `worldcover-landcover.example.yaml`. Footprints and land-cover pixels are context only; they do not describe unoccupied premises.
5. **Population:** use `worldpop-age-sex.example.yaml` or an existing population manifest with the exact raster/table release, year, resolution, checksum and citation. For BPS, copy `bps-area-table.example.yaml`, preserve official area codes, provide the exact table title and publication URL, and cross-check totals by area before marking `verified_against_publication`.
6. **Administrative boundaries:** use `osm-boundaries.example.yaml` or the administrative-boundary template; record the issuer, source release, boundary level and verification source. Do not label an unofficial or unreviewed boundary verified.
7. **Hazards and terrain:** use a flood layer only if the responsible agency publishes the data with clear reuse terms. A public web map is not sufficient licensing evidence. If no qualifying file is available, leave hazard status `unknown`. Record DEM source, vertical units, resolution, CRS, and processing method before deriving slope.
8. **RDTR/zoning:** copy `rdtr-zoning.example.yaml` only for an official published GIS file with documented terms. Set `regulatory_status` to `verified_official` only after checking authority, effective period and location-level applicability. Otherwise retain `unknown`.
9. **User observations:** use `user-survey.example.yaml`. Collect only the listed fields with explicit consent, never include names, telephone numbers, emails, or free-text identity details. The importer excludes rows without consent and ignores unmapped columns.

For a spatial GeoJSON or supported local geospatial file, run from `backend` after reviewing its manifest:

```powershell
python -m app.services.import_dataset --manifest ..\data\manifests\my-dataset.yaml --input ..\data\raw\my-dataset.geojson --output ..\data\processed\my-dataset.normalized.json --persist
```

For a BPS area-population CSV, run:

```powershell
python -m app.services.bps_importer --manifest ..\data\manifests\my-bps-table.yaml --input ..\data\raw\my-bps-table.csv
```

The manifests are examples: replace all example values. `--persist` writes the normalized spatial features and provenance to the database selected by `DATABASE_URL`. The BPS importer stores matched area observations with their starting verification state. Re-run the data audit after import and compare the release and totals with the cited source. A manifest alone cannot promote a dataset; a verification record with reviewer/date and publication evidence is required.

## Verify locally

```powershell
cd backend
python -m pytest -q -p no:cacheprovider
python -m ruff check app tests
python -m compileall -q app tests
```

```powershell
cd frontend
npm run typecheck
npm run lint
npm run build
npm run e2e
```

`make test`, `make lint`, and `make e2e` are also provided when GNU Make is installed. Playwright requires Chromium. The exact commands actually run and any platform blockers are recorded in [docs/verification-report.md](docs/verification-report.md).

## API and data notes

New endpoints are listed in [docs/analysis-menu.md](docs/analysis-menu.md). Data import, privacy and Q rules are in [docs/data-governance.md](docs/data-governance.md); the method definitions are in [docs/scoring-method.md](docs/scoring-method.md). Known limitations are listed in [docs/limitations.md](docs/limitations.md), and the milestone checkpoints are in [docs/PROGRESS.md](docs/PROGRESS.md).

See [DISCLAIMER.md](DISCLAIMER.md) and [LICENSES_AND_ATTRIBUTION.md](LICENSES_AND_ATTRIBUTION.md). The map does not use Google Maps or Places data.
