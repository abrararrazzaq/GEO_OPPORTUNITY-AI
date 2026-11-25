# Licenses and attribution

License eligibility is evaluated for the exact file, release, and upstream source. A manifest declaration is metadata, not legal review. Sources with missing, unclear, restricted, or incompatible terms are excluded from default analysis. The license gate blocks Google Maps and Google Places sources.

| Source | Terms and attribution to record | Current handling |
|---|---|---|
| OpenStreetMap data | Open Database License (ODbL); attribute `© OpenStreetMap contributors` and link to [OSM copyright and license](https://www.openstreetmap.org/copyright). Extracts and derived database obligations need review. | No empirical local POI/roads bundle is included. The interactive basemap displays OSM attribution. |
| Overture Places | The Places theme is multi-license. Record the dated release and per-feature source/license; follow [Places guide](https://docs.overturemaps.org/guides/places/) and [attribution rules](https://docs.overturemaps.org/attribution/). | No local Places extract is bundled. Do not infer a single license from the theme name. |
| WorldPop | CC BY 4.0; cite the exact product/release and source. See the [WorldPop reuse FAQ](https://www.worldpop.org/faq/). | A local 2023 modeled raster is identified as a modeled estimate; check its release record and checksum before selection. |
| ESA WorldCover | CC BY 4.0. Include the version/year-specific attribution printed on [ESA's data-access page](https://esa-worldcover.org/en/data-access). | Template only; no local layer is included by the seed. |
| BPS tables | Review the exact publication, dataset terms, table title, publication URL and permitted reuse before import. A government source URL alone is not a license. | Local area tables remain pending/restricted until reviewed and publication-matched. |
| RBI/admin boundaries and RDTR | Review the issuing authority's exact release and reuse terms, plus valid period and geographic applicability. | Local unreviewed boundary data stays unverified. Zoning stays unknown without a verified official layer. |
| User survey | User-provided, consented observations with a documented purpose and retention policy. Do not include personal identifiers. | Stored in a restricted catalog record, labeled user-provided, and excluded from the default analysis. |
| Synthetic fixtures | `CC0-1.0`; attribution `GeoOpportunity AI synthetic demo fixture`. Names and records are fictitious. | Included for software demonstration and test expectations only. |

The OSM tile service is a display layer, separate from the application's analysis data. Follow the tile provider's usage policy and keep the visible attribution. Never scrape map views or use them to derive stored POI records. No Google Maps or Google Places data, calls, caches, or storage are permitted.

License review is a project gate, not legal advice. Save each source license, attribution text, access date, release identifier and checksum with the manifest. When terms cannot be resolved, retain `restricted` or `pending_review` and keep the data out of default analysis.
