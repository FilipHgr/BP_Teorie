# Struktura teoretické části bakalářské práce

**Téma:** Srovnávací analýza architektonických principů, výkonnosti a bezpečnosti komunikačních protokolů REST, GraphQL a gRPC

---

## Část A — Teoretická rešerše

### 1. Webová API a komunikace
Společný základ, aby se dala všechna tři rozhraní srovnávat férově.

- Pojem API, model klient–server, webové API
- HTTP: metody, stavové kódy, hlavičky
- HTTP/1.1 vs HTTP/2 (multiplexing, binární rámce) — podklad pro gRPC
- Serializace: JSON vs Protocol Buffers (textová vs binární)

### 2. REST
- Fieldingova disertace, architektonická omezení (client–server, stateless, cache, uniform interface, layered, code-on-demand)
- Zdroje, URI, reprezentace, sémantika metod a stavových kódů
- Richardson Maturity Model, HATEOAS
- Slabiny: over-/under-fetching, verzování

### 3. GraphQL
- Motivace (Facebook), řešení over-/under-fetchingu
- Typový systém a schéma (SDL), jediný endpoint
- Dotazy, mutace, subscriptions, resolvery
- Problém N+1 a princip DataLoaderu

### 4. gRPC
- Model RPC vs resource-based přístup
- Protocol Buffers jako IDL (`.proto`), generování stubů
- HTTP/2 jako transport
- Unary a streaming (server/client/bidirectional)

### 5. Bezpečnost API
Vlastní kapitola pokrývající požadavek zadání na analýzu hrozeb a návrh mitigací. Doporučená symetrická struktura: nejdřív sdílené hrozby, pak specifika každé architektury.

- Sdílený rámec: autentizace vs autorizace, transportní bezpečnost (TLS), OWASP API Security Top 10 jako referenční osnova
- Specifika REST: injection, nadměrné odhalení dat, chybějící rate limiting, BOLA/IDOR
- Specifika GraphQL: hloubka a složitost dotazů (DoS), introspekce, batching útoky, over-exposure přes schéma
- Specifika gRPC: bezpečnost na úrovni HTTP/2, autentizace přes metadata/mTLS, reflexe
- Přehled mitigačních technik (rate limiting, query cost analysis, depth limiting, validace, mTLS) — teoretický základ aplikovaný v části B

### 6. Metodika srovnání a výkonnostní testování
- Kritéria: výkonnostní, kvalitativní (architektura), bezpečnostní
- Zátěžové testování: virtuální uživatelé, typy zátěžových profilů (constant, ramp-up, spike, stress) — pokrývá „různé typy zátěže" ze zadání
- Metriky: latence a percentily (p50/p95/p99), propustnost (RPS), velikost payloadu, chybovost, vytížení prostředků (CPU, RAM)
- Nástroje (k6 a alternativy) a zdůvodnění volby
- Related work: existující srovnání REST/GraphQL/gRPC

---

## Část B — Návrh a popis benchmarku

Koncepční popis navrženého a naprogramovaného řešení — bez naměřených čísel.

### 7. Cíle a návrh experimentu
- Výzkumné otázky (odvozené přímo ze tří pilířů zadání)
- Přístup: tři implementace nad jednou sdílenou datovou vrstvou
- Zásada férovosti srovnání (stejná data, stejné dotazy, izolace rozdílu na úroveň API)

### 8. Datová vrstva a doménový model
- Volba e-commerce domény a zdůvodnění (bohatost vztahů, prostor pro vnořené dotazy i pro demonstraci bezpečnostních rizik)
- Schéma PostgreSQL 16: entity, vztahy, indexy, `order_status` enum, self-reference kategorií, `UNIQUE` na recenzích
- Seed skript (generování dat, many-to-many)
- Sdílená datová vrstva: psycopg3, connection pooling, `shared/database.py`, `shared/queries.py` — a proč je společná

### 9. Implementace tří rozhraní
- REST (FastAPI): mapování zdrojů, serializace přes Pydantic
- GraphQL (Strawberry): schéma, resolvery, per-request DataLoader
- gRPC (grpcio): `.proto`, generované stuby, servisní metody

### 10. Návrh měření a testovací prostředí
- Definice měřených operací a jejich shodné mapování do všech tří technologií (jednoduché čtení, vnořené vztahy, zápis)
- Návrh zátěžových scénářů (napojení na typy profilů z kap. 6)
- Sběr metrik včetně vytížení prostředků (měření CPU/RAM kontejnerů)
- Orchestrace: Docker Compose (služby, healthchecky, volumes)

### 11. Návrh bezpečnostní analýzy *(volitelně samostatná kapitola)*
- Které z hrozeb z kap. 5 se na referenční implementaci konkrétně demonstrují nebo se ověřuje jejich mitigace
- Lze sloučit do kap. 9 jako podkapitolu, pokud není žádoucí samostatný oddíl

---

## Poznámky k obhajobě
- Výsledný „set doporučení" ze zadání by měl mít oporu už v teorii — kritéria z kap. 6 se přímo promítnou do závěrečné rozhodovací matice (typ aplikace → doporučený protokol).
- Před psaním rozhodnout, zda bude bezpečnost reálně **měřena/demonstrována** na implementaci, nebo zpracována čistě analyticky — to určí rozdělení mezi část A a část B.
- Kapitoly 2–4 psát strukturně symetricky (stejné podnadpisy), aby srovnání působilo férově už na úrovni textu.
