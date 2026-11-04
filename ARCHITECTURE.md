# ARCHITECTURE: Next.js App Router + SQLite + Jotai (FSD-lite)

> 업무형 웹 과제(사용자 조회 + 관리자 운영)를 180분 안에 만들 때 쓰는 구조 지도.
> 목표: **책임이 폴더로 보이고**, 관리자/사용자가 분리되고, **동시 수정과 서버 장애에 대한 답이 구조 안에 있는 것.**
> 과제가 작으면 "필수"만 만든다. "선택"은 필요가 확인될 때 추가한다.

---

## 0. 원칙 다섯 줄

1. **라우팅은 얇게**: `src/app/`의 `page.tsx`, `route.ts`에는 로직을 넣지 않는다. views를 불러오거나 `server/`를 호출하기만 한다.
2. **서버 로직은 `src/server/`에만**: 입력 반영 / 계산 / 게시 / 조회 / 작업 / DB를 나눈다. 화면 코드는 `server/`를 직접 import하지 않는다.
3. **계산은 순수 함수**: `server/core`는 DB도 HTTP도 모른다. 입력을 받아 결과를 돌려주고, 단독으로 테스트한다.
4. **사용자는 확정본만 읽는다**: 조회는 게시된 스냅샷만 읽는다. 계산을 직접 돌리지 않는다.
5. **쓰기는 버전으로 지킨다**: 설정·데이터 저장은 낙관적 잠금, 무거운 재계산은 한 번에 하나, 게시는 트랜잭션.

---

## 1. 전체 그림

```
 ┌──────────── 브라우저 ────────────┐
 │  사용자 화면 (/)       관리자 화면 (/admin/*)        │
 │  - 조회 폼             - 업로드·규칙·미리보기·게시·이력 │
 │  - Jotai: 화면 상태     - Jotai: 폼 초안, 선택 상태   │
 │  - 마지막 결과 캐시(localStorage)                    │
 └──────┬──────────────────────────┬───────────────────┘
        │ GET /api/public/*         │ /api/admin/* (세션 쿠키)
 ┌──────▼──────────────────────────▼───────────────────┐
 │  Next.js (Node 런타임, 0.0.0.0:3000, 단일 프로세스)       │
 │  src/app/api/**/route.ts  ← 얇은 HTTP 계층 (검증·권한·상태코드) │
 │        │                                             │
 │  src/server/                                         │
 │   auth/     관리자 세션, 사용자 본인 확인                 │
 │   import/   업로드 → 검증 → 데이터셋 버전 저장             │
 │   core/     계산 (순수 함수)                           │
 │   jobs/     재계산 작업: 한 번에 하나, 상태 기록            │
 │   publish/  초안 → 게시: 트랜잭션, 버전, 스냅샷, 이력        │
 │   read/     게시본 읽기, 사용자용 최소 응답(DTO)            │
 │   db/       SQLite 연결, 스키마, 트랜잭션 헬퍼             │
 └──────┬─────────────────────────────┬────────────────┘
        │                             │
   ┌────▼─────┐              ┌────────▼──────────┐
   │ SQLite    │              │ data/snapshots/    │
   │ (WAL 모드) │              │ v{N}.json + latest │
   └──────────┘              └───────────────────┘
```

---

## 2. 계층과 의존 규칙 (FSD-lite)

```
src/app        Next 라우팅 + 전역 Provider·스타일   (FSD의 app 층을 겸함)
   ↓
src/views      화면 단위 조립 (FSD의 pages 층. 이름을 views로 바꿈)
   ↓
src/widgets    [선택] 여러 feature를 묶은 큰 블록
   ↓
src/features   사용자 행동: 조회, 업로드, 규칙 수정, 게시
   ↓
src/entities   도메인 단위: 타입, 표시 컴포넌트, 클라이언트 API 함수
   ↓
src/shared     UI 기본 요소, 유틸, 디자인 토큰, 공용 타입

src/server     서버 전용 (server-only). app/api와 Server Action에서만 import
```

**규칙**
- import는 **위에서 아래로만**. 같은 층의 다른 슬라이스끼리 import하지 않는다 (공유가 필요하면 아래 층으로 내린다).
- 각 슬라이스는 `index.ts`로 공개 API만 내보낸다. 바깥에서 내부 파일을 직접 import하지 않는다.
- `src/server/**` 파일 맨 위에 `import "server-only";` → 클라이언트 번들에 섞이면 빌드 에러로 바로 잡힌다.
- 클라이언트와 서버가 같이 쓰는 타입·검증 스키마는 `src/shared/contracts/`에 둔다.

**이름 충돌 주의**
- FSD의 `pages` 층을 `src/pages`로 만들면 Next.js가 **Pages Router로 인식**할 수 있다. → `src/views`로 쓴다.
- FSD의 `app` 층은 Next의 `src/app`과 합친다 (Provider, 전역 CSS, 레이아웃).

---

## 3. 폴더 구조

`●` 필수 / `○` 선택 (필요가 확인될 때만)

```
.
├── data/                              ● 런타임 데이터 (git 제외 가능, 제출 시 샘플 포함 여부는 README 따름)
│   ├── app.db                         ● SQLite
│   ├── uploads/                       ○ 업로드 원본 보관
│   └── snapshots/                     ● 게시 스냅샷 (public/ 아님, 7장 참고)
├── public/
│   ├── fonts/                         ○ Pretendard GOV + OFL.txt (DESIGN.md)
│   └── sw.js                          ○ 서비스 워커 (7-5)
├── src/
│   ├── app/
│   │   ├── layout.tsx                 ● 서체, 헤더, Providers
│   │   ├── providers.tsx              ○ Jotai Provider (쓸 때만)
│   │   ├── globals.css                ● DESIGN.md 토큰
│   │   ├── (user)/
│   │   │   └── page.tsx               ● 사용자 조회 → views/user-lookup
│   │   ├── admin/
│   │   │   ├── layout.tsx             ● 관리자 셸 + 서버에서 세션 확인
│   │   │   ├── login/page.tsx         ● 관리자 로그인
│   │   │   ├── data/page.tsx          ● 업로드·검증 결과
│   │   │   ├── settings/page.tsx      ○ 운영 규칙 수정 (규칙이 있는 과제면 ●)
│   │   │   ├── preview/page.tsx       ○ 초안 미리보기·비교 (게시가 있는 과제면 ●)
│   │   │   ├── publish/page.tsx       ○ 게시 (게시가 있는 과제면 ●)
│   │   │   └── history/page.tsx       ○ 변경 이력
│   │   └── api/
│   │       ├── public/
│   │       │   ├── lookup/route.ts    ● 사용자 조회 (게시본만, 최소 응답)
│   │       │   └── snapshot/route.ts  ○ 최신 게시 메타 (버전, 게시 시각)
│   │       └── admin/
│   │           ├── login/route.ts     ● 세션 발급
│   │           ├── datasets/route.ts  ● 업로드 (검증 후 새 버전)
│   │           ├── settings/route.ts  ○ GET 현재값+version / PUT 낙관적 잠금
│   │           ├── jobs/route.ts      ○ 재계산 시작(POST) / 상태 조회(GET)
│   │           ├── publish/route.ts   ○ 초안 게시
│   │           └── audit/route.ts     ○ 이력 조회
│   ├── views/                         ● 화면 조립 (user-lookup, admin-data, admin-settings …)
│   ├── widgets/                       ○ 화면이 3개 이상이고 블록이 반복될 때
│   ├── features/
│   │   ├── lookup/                    ● ui/ model/(atoms) api/
│   │   ├── upload-dataset/            ● 업로드 폼, 검증 결과 표시
│   │   ├── edit-settings/             ○ 규칙 폼, 충돌(409) 처리
│   │   ├── run-job/                   ○ 재계산 버튼, 진행 상태 폴링
│   │   └── publish-draft/             ○ 게시 확인, 비교
│   ├── entities/
│   │   └── <도메인>/                   ● model/types.ts, ui/(카드·배지), api/(fetch 함수)
│   ├── shared/
│   │   ├── ui/                        ● Button, Badge, Table, Banner, Dialog (DESIGN.md)
│   │   ├── lib/                       ● fetchJson(타임아웃), format, cache
│   │   └── contracts/                 ● 요청·응답 타입, 검증 스키마
│   ├── server/
│   │   ├── db/                        ● client.ts(연결·PRAGMA), schema.sql, tx.ts
│   │   ├── auth/                      ● admin-session.ts, user-identity.ts
│   │   ├── import/                    ● parse.ts, validate.ts, save.ts
│   │   ├── core/                      ● 계산 순수 함수 + *.test.ts
│   │   ├── jobs/                      ○ queue.ts (재계산이 무거울 때 ●)
│   │   ├── publish/                   ○ publish.ts, snapshot.ts (게시가 있으면 ●)
│   │   ├── read/                      ● 게시본 읽기, toUserDto()
│   │   └── audit/                     ○ log.ts (관리자 쓰기가 있으면 ●)
│   └── middleware.ts                  ○ /admin 1차 차단 (Next 16부터는 proxy.ts)
└── tests/                             ● 계산·잠금·권한 테스트, 수용 스크립트
```

---

## 4. 관리자 / 사용자 분리

### 분리 지점 4곳

| 분리 지점 | 사용자 | 관리자 |
|---|---|---|
| 라우트 | `/` (route group `(user)`) | `/admin/*` |
| API 네임스페이스 | `/api/public/*` (읽기 전용) | `/api/admin/*` (쓰기) |
| 서버 모듈 | `server/read` 만 | `server/import`, `jobs`, `publish`, `audit` |
| 응답 데이터 | **본인 결과의 최소 필드** (DTO) | 전체 데이터, 검증 결과, 이력 |

### 권한 확인 (2단)

```
요청 → [1단] middleware/proxy: /admin/*, /api/admin/* 에 세션 쿠키 없으면 로그인으로
     → [2단] route.ts / Server Action / admin/layout.tsx: requireAdmin() 으로 세션 검증  ← 반드시
```
- **미들웨어만으로 막지 않는다.** 미들웨어를 우회하는 취약점 사례가 있었고, 미들웨어는 Edge 런타임이라 DB 확인도 어렵다. 실제 판정은 2단에서.
- `requireAdmin()`은 서명된 httpOnly 쿠키를 검증하고 `{ operatorName }`을 돌려준다 → 감사 로그의 "누가"에 쓴다.
- 과제 수준의 인증: 운영자 이름 + 공용 비밀번호(환경 변수) → 서명 쿠키. 실제 운영이라면 사내 SSO로 대체한다고 DECISIONS.md에 적는다.

### 사용자 쪽 개인정보

- 사용자 조회는 **본인 확인 수단**을 담당자와 합의한다 (예: 사번만으로는 남의 결과를 볼 수 있다 → 추가 확인값 또는 사내 인증).
- `server/read/toUserDto()`가 **화이트리스트로** 필드를 고른다. 주소·연락처·단가 같은 민감 필드는 DB에서 읽더라도 응답에 넣지 않는다.
- 조회 API에 간단한 요청 제한(같은 IP 분당 N회)을 두면 무작위 대입을 늦출 수 있다 (○).

### 권한 매트릭스 (DECISIONS.md에 그대로 옮겨도 됨)

| 행동 | 사용자 | 관리자 |
|---|---|---|
| 본인 결과 조회 | ● | ● |
| 타인 결과 조회 | ✕ | ● (관리 화면에서만) |
| 데이터 업로드 | ✕ | ● |
| 규칙 수정 | ✕ | ● (낙관적 잠금) |
| 재계산 실행 | ✕ | ● (한 번에 하나) |
| 게시 / 되돌리기 | ✕ | ● (트랜잭션, 이력) |

---

## 5. 데이터 흐름: 입력 → 계산 → 초안 → 게시 → 조회

```
[업로드] ──검증 실패──▶ 거부 + 실패 행 보고 (기존 데이터셋 유지)
   │ 통과
   ▼
datasets v(N+1) ─┐
settings v(M)  ──┼──▶ [재계산 작업] ──▶ drafts (based_on: dataset vN+1, settings vM)
                 │        (한 번에 하나)        │
                 │                             ▼
                 │                     [미리보기·비교] 관리자 확인
                 │                             │
                 │       입력 버전이 바뀌었으면 ◀─┤ 게시 시 재확인
                 │       "초안이 오래됨" 거부       │ 같으면
                 │                             ▼
                 └──────────────────▶ publications vK  +  snapshots/vK.json  +  audit_log
                                               │
                                               ▼
                                   [사용자 조회] latest 스냅샷 읽기 → 최소 DTO
```

- 초안 상태: `ready` → `published` / 입력이 바뀌면 `stale`
- 사용자는 **게시된 것만** 본다. 관리자가 규칙을 바꾸고 재계산 중이어도 사용자 화면은 흔들리지 않는다.

---

## 6. 동시성 제어 (관리자 여러 명)

### 6-1. 어떤 경쟁이 생기나

Node는 한 프로세스라도 `await` 사이에 다른 요청이 끼어든다. SQLite가 쓰기를 직렬화해도 **"읽고 → 고치고 → 쓰기"** 사이의 논리적 덮어쓰기는 막지 못한다.

| 상황 | 문제 | 대응 |
|---|---|---|
| A, B가 같은 규칙 화면을 열고 각각 저장 | 나중 저장이 앞의 변경을 조용히 덮어씀 (lost update) | **낙관적 잠금** (6-2) |
| A, B가 동시에 재계산 버튼 | 무거운 계산 두 번, 결과 섞임 | **작업 단일 실행** (6-3) |
| A가 재계산하는 동안 B가 새 데이터 업로드 | 옛 입력으로 만든 초안이 게시됨 | **초안의 입력 버전 기록 + 게시 시 재확인** (6-4) |
| A, B가 동시에 게시 | 버전 번호 충돌, 스냅샷 꼬임 | **게시 트랜잭션** (6-4) |

### 6-2. 낙관적 잠금 (설정·데이터 수정)

```sql
-- settings: id, json, version, updated_by, updated_at
UPDATE settings
   SET json = ?, version = version + 1, updated_by = ?, updated_at = datetime('now')
 WHERE id = 1 AND version = ?;          -- 클라이언트가 GET 때 받은 version
```

```ts
// server/settings/save.ts (개념 예시, better-sqlite3)
const r = db.prepare(SQL_UPDATE).run(json, operator, expectedVersion);
if (r.changes === 0) {
  const cur = db.prepare("SELECT version, updated_by, updated_at FROM settings WHERE id = 1").get();
  return { ok: false, status: 409, current: cur };   // 충돌
}
audit("settings.update", operator, { from: expectedVersion });
return { ok: true, version: expectedVersion + 1 };
```

- 클라이언트: GET으로 받은 `version`을 PUT에 같이 보낸다. 409를 받으면 DESIGN.md의 **Conflict Dialog** ("다른 사용자가 먼저 수정했습니다 · 수정자 · 시각 · [최신 내용 불러오기]").
- 비관적 잠금(편집 중 잠금)은 쓰지 않는다: 창을 닫으면 잠금이 남는 문제가 있고, 소수 운영자 환경에서는 낙관적 잠금이 충분하다. (DECISIONS.md에 대안으로 기록)

### 6-3. 재계산 작업: 한 번에 하나

```sql
-- jobs: id, kind, status(queued|running|done|failed), input_dataset_version, input_settings_version,
--       requested_by, started_at, finished_at, error, draft_id
CREATE UNIQUE INDEX IF NOT EXISTS ux_jobs_active
  ON jobs(kind) WHERE status IN ('queued', 'running');   -- 같은 종류 작업은 동시에 하나만
```

```
POST /api/admin/jobs
  → INSERT INTO jobs(status='queued', 입력 버전들) 
     ├─ 성공: 202 { jobId }  → 프로세스 내 큐가 실행
     └─ 유니크 위반: 409 { runningJobId, requested_by, started_at } → "이미 ○○님이 실행 중"
GET /api/admin/jobs?id=  → 상태 폴링 (2초 간격)
```

- 실행기(`server/jobs/queue.ts`): 프로세스 안의 단순 직렬 큐(Promise 체인). **진짜 잠금은 DB의 유니크 인덱스**가 맡는다. 큐는 실행 순서만.
- 서버가 재시작되면 `running`으로 남은 작업을 `failed(재시작)`로 정리하는 코드를 시작 시 한 번 실행한다.
- 계산 결과는 `drafts`에 `based_on_dataset_version`, `based_on_settings_version`과 함께 저장.
- 계산이 짧으면(1초 이내) 큐 없이 `BEGIN IMMEDIATE` 트랜잭션 안에서 바로 계산해도 된다 (○). 이때도 입력 버전은 기록한다.

### 6-4. 게시 트랜잭션

```ts
// server/publish/publish.ts (개념 예시)
const publish = db.transaction((draftId, operator) => {
  const d = getDraft(draftId);
  const cur = currentVersions();                     // 현재 dataset, settings 버전
  if (d.based_on_dataset_version !== cur.dataset || d.based_on_settings_version !== cur.settings) {
    markDraftStale(draftId);
    throw new Conflict("초안 이후 입력이 바뀌었습니다. 다시 계산하세요.");
  }
  const v = insertPublication(draftId, operator);    // AUTOINCREMENT 버전
  audit("publish", operator, { version: v, draftId });
  return v;
});
const version = publish.immediate(draftId, operator); // BEGIN IMMEDIATE: 쓰기 잠금을 먼저 잡음
writeSnapshotAtomic(version, buildSnapshot(version)); // 7-2 (트랜잭션 밖에서 파일 쓰기)
```

- 되돌리기: 이전 publication 버전을 `latest`로 다시 지정하는 것도 같은 트랜잭션 + 감사 로그.

### 6-5. SQLite 설정

```ts
db.pragma("journal_mode = WAL");     // 읽기와 쓰기가 서로 덜 막힘
db.pragma("busy_timeout = 5000");    // 잠금 대기 최대 5초 (즉시 SQLITE_BUSY 대신)
db.pragma("foreign_keys = ON");
```
- 라이브러리: `better-sqlite3` (동기 API, 트랜잭션 헬퍼 `.immediate()`). 설치(네이티브 빌드)가 실패하면 Node 내장 `node:sqlite`로 대체 (Node 22.13+).
- Route Handler에 `export const runtime = "nodejs";`, 데이터 API는 `export const dynamic = "force-dynamic";`.

### 6-6. 내가 직접 검증하는 법 (VERIFY.md)

```bash
# 같은 version으로 두 번 동시 저장 → 하나는 200, 하나는 409 여야 함
V=$(curl -s -b admin.txt localhost:3000/api/admin/settings | jq .version)
curl -s -o /dev/null -w "%{http_code}\n" -b admin.txt -X PUT -H 'content-type: application/json' \
  -d "{\"version\":$V,\"json\":{\"capacity\":40}}" localhost:3000/api/admin/settings &
curl -s -o /dev/null -w "%{http_code}\n" -b admin.txt -X PUT -H 'content-type: application/json' \
  -d "{\"version\":$V,\"json\":{\"capacity\":45}}" localhost:3000/api/admin/settings &
wait
# 재계산 버튼 동시 2회 → 202 하나, 409 하나
```
- 테스트를 테스트: `WHERE ... AND version = ?` 조건을 임시로 지우면 위 검증이 200, 200으로 바뀌어야 한다.

---

## 7. 장애 대비 조회 (스냅샷 + 클라이언트 캐시)

### 7-1. 무엇을 막는가

| 장애 | 사용자 영향 | 대응 | 커버 |
|---|---|---|---|
| 재계산 중, 계산 실패 | 없음 | 사용자는 게시본만 읽음 (5장) | 구조로 해결 |
| DB 잠금·손상, 쿼리 오류 | 없음 | 조회는 **스냅샷 파일**을 먼저 읽음 (7-2, 7-3) | 스냅샷 |
| 네트워크 끊김, API 응답 지연 | 화면은 떠 있음 | **클라이언트 캐시** + "○○ 기준 저장본" 배너 (7-4) | 캐시 |
| Next 프로세스 전체 다운 | 열려 있던 화면은 캐시로 유지, **새로고침은 실패** | 서비스 워커(7-5) 또는 외부 정적 호스팅 | 대안으로 설명 |

핵심 문장: **"쓰기(관리자)는 멈춰도 읽기(사용자)는 산다."**

### 7-2. 게시 스냅샷

- 게시할 때 사용자 조회에 필요한 **최소 데이터만** 담은 JSON을 만든다.
  `data/snapshots/v{N}.json` + `data/snapshots/latest.json` (또는 latest 포인터 파일)
- 원자적 쓰기: 임시 파일에 쓰고 `rename` (같은 파일시스템에서 rename은 원자적) → 읽는 쪽이 반쯤 쓴 파일을 보지 않는다.
- **`public/`에 쓰지 않는다.** Next.js는 빌드 시점에 `public/`에 있던 파일만 제공하고, 실행 중에 추가된 파일은 제공하지 않는다. → `data/snapshots/`에 쓰고 Route Handler가 읽어서 응답.
- 스냅샷 메타: `{ version, publishedAt, publishedBy, inputVersions }` → 화면의 "기준 시각".

### 7-3. 조회 API: 스냅샷 우선

```
GET /api/public/lookup?id=...&check=...
  1) 본인 확인 (server/auth/user-identity)
  2) latest 스냅샷에서 해당 사용자 결과 찾기  ← DB 없이 응답 가능
     (스냅샷을 메모리에 캐시, 파일 mtime이 바뀌면 다시 읽기)
  3) toUserDto()로 최소 필드만
  4) 응답: { data, meta: { version, publishedAt } }
  - 스냅샷이 없으면(아직 게시 전) 404 + "아직 게시된 결과가 없습니다"
```

### 7-4. 클라이언트 캐시 (Jotai `atomWithStorage`)

```ts
// features/lookup/model/atoms.ts (개념 예시)
import { atomWithStorage } from "jotai/utils";
export const lastResultAtom = atomWithStorage<CachedResult | null>("lookup:last", null);
// CachedResult = { key: 조회키 해시, data: 최소 DTO, meta: { version, publishedAt }, savedAt }
```

```
조회 → fetchJson(url, { signal: AbortSignal.timeout(5000) })
  ├─ 성공: 화면 표시 + lastResultAtom 갱신
  └─ 실패(네트워크·타임아웃·5xx):
       캐시가 있고 같은 조회키 → 결과 표시 + 경고 배너 "○○ 기준 저장된 결과입니다. 서버에 연결할 수 없어 최신이 아닐 수 있습니다."
       캐시 없음 → 오류 배너 + [다시 시도]
```

- **공용 PC 주의**: 개인 결과를 브라우저에 저장하면 다음 사람이 볼 수 있다.
  최소 필드만 저장, **다른 조회키로 조회하면 이전 캐시 삭제**, 저장 기간 제한(예: 당일), [저장된 결과 지우기] 버튼. 담당자에게 공용 기기 여부를 확인하고 DECISIONS.md에 기록.
- `atomWithStorage`는 서버 렌더링 때 초기값(null)으로 그려지고 브라우저에서 저장값으로 바뀐다 → 이 컴포넌트는 `"use client"`.

### 7-5. 프로세스 전체 다운 대비 (선택, 설명용)

- **서비스 워커** (`public/sw.js`, 빌드 전에 파일이 있어야 제공됨): 사용자 화면의 HTML·JS·CSS를 캐시해 서버가 꺼져도 화면을 띄우고, 데이터는 7-4 캐시로 표시.
- **외부 정적 호스팅**: 게시 시 스냅샷을 사내 파일 서버나 정적 호스팅에 복사 → 앱 서버와 장애를 분리.
- **운영 대안**: 게시와 동시에 인쇄본·메신저 공지.
- 180분 과제에서는 보통 **7-2 ~ 7-4까지 구현**, 7-5는 DECISIONS.md 리스크 표에 대안으로 기록.

---

## 8. Jotai 사용 범위

| 쓴다 | 쓰지 않는다 |
|---|---|
| 조회 폼 입력값, 선택한 날짜·필터 | 서버 데이터의 원본 저장소 (서버 컴포넌트·fetch로 가져온다) |
| 관리자 폼 초안 (저장 전 편집 상태) | 권한·세션 판단 (서버가 판단) |
| 마지막 조회 결과 캐시 (`atomWithStorage`) | 계산 로직 |
| 여러 컴포넌트가 공유하는 UI 상태 (탭, 모달 열림) | 한 컴포넌트 안에서 끝나는 상태 (`useState`로 충분) |

- atom은 `features/<기능>/model/`에 둔다. `shared`에 전역 atom을 쌓지 않는다.
- Provider는 `src/app/providers.tsx` 하나 (요청 간 상태가 섞이지 않게 클라이언트 컴포넌트에서만 사용).
- Jotai가 필요 없을 정도로 작으면 쓰지 않는다. **"왜 전역 상태가 필요했나"에 답할 수 있을 때만.**

---

## 9. 데이터 모델 (공통 뼈대)

| 테이블 | 핵심 컬럼 | 역할 |
|---|---|---|
| `datasets` | id, kind, version, row_count, uploaded_by, uploaded_at, status | 업로드 단위 버전 |
| `<도메인 행>` | dataset_id, … | 업로드된 실제 데이터 |
| `settings` | id=1, json, **version**, updated_by, updated_at | 운영 규칙 (낙관적 잠금) |
| `jobs` | id, kind, status, input_*_version, requested_by, started_at, finished_at, error, draft_id | 재계산 작업 (활성 작업 유니크) |
| `drafts` | id, based_on_dataset_version, based_on_settings_version, result_json, metrics_json, status | 계산 결과 초안 |
| `publications` | version(PK), draft_id, published_by, published_at, snapshot_path, note | 게시 이력 |
| `audit_log` | id, at, actor, action, target, detail_json | 누가 언제 무엇을 |

- `metrics_json`: 계산 결과 검증 지표 (예: 제약 위반 0건, 미배정 N명, 계산 시간 ms) → 미리보기 화면과 VERIFY.md 근거.

---

## 10. 과제 유형별 필수 / 선택

| 과제에 있는 것 | 추가로 필수가 되는 것 |
|---|---|
| 사용자 조회만 | `api/public/lookup`, `server/read`, 스냅샷 or 메모리 캐시, 클라이언트 캐시 |
| 관리자 업로드 | `admin/data`, `server/import`(검증·실패 행 보고), `datasets` 버전, `audit_log` |
| 운영 규칙 수정 | `admin/settings`, `settings.version` 낙관적 잠금, Conflict Dialog |
| 무거운 계산 | `server/core` 순수 함수 + 테스트, `jobs` 단일 실행, `metrics` |
| 결과 공지·게시 | `drafts` → `publications`, 게시 트랜잭션, 스냅샷, 되돌리기 |
| 개인 데이터 조회 | 본인 확인, `toUserDto()` 화이트리스트, 공용 PC 캐시 정책 |

---

## 11. 예시 매핑

### A. 재고 조회 (사용자만, 매일 파일 교체)

```
src/app/(user)/page.tsx                → views/stock-lookup
src/app/api/public/search/route.ts     → server/read/search.ts
src/server/import/load-latest.ts       최신 파일 선택, 단가 컬럼 제거(화이트리스트), 검증 실패 시 이전 파일 유지
src/server/core/summarize.ts (+test)   창고 합산, 상태 판정 (빈칸·음수 = 확인 필요)
src/server/core/search.ts (+test)      장비 번호 / 별칭 / 부품 번호
src/features/lookup/                   검색 폼, lastResultAtom (서버 장애 시 마지막 결과)
src/entities/part/ui/PartCard.tsx      결과 카드, 상태 배지
```
관리자·게시·잠금은 **없음** (요구 사항 밖). 6장은 쓰지 않고, "파일 교체를 여러 명이 하면?"은 리스크 표에 대안으로 기록.

### B. 관리자 + 사용자 (업로드 → 규칙 → 계산 → 게시 → 조회)

```
src/app/(user)/page.tsx                      → views/user-lookup
src/app/admin/{data,settings,preview,publish,history}/page.tsx → views/admin-*
src/app/api/public/lookup/route.ts           → server/auth/user-identity + server/read
src/app/api/admin/datasets/route.ts          → server/import (검증 → datasets v+1)
src/app/api/admin/settings/route.ts          → 낙관적 잠금 (409)
src/app/api/admin/jobs/route.ts              → server/jobs (활성 작업 유니크) → server/core
src/app/api/admin/publish/route.ts           → server/publish (BEGIN IMMEDIATE, 입력 버전 재확인, 스냅샷)
src/features/{upload-dataset,edit-settings,run-job,publish-draft,lookup}/
src/entities/<결과 도메인>/                    타입, 결과 카드, 표
```

---

## 12. Codex 지시 예시

**구조 세팅 (계획 승인 후 1회)**
```
[목표] ARCHITECTURE.md 3장 구조에서 이번 과제에 필요한 ● 폴더만 만든다. ○는 만들지 않는다.
[제약] FSD pages 층은 src/views. src/server/** 맨 위에 import "server-only". 라우트 파일에는 로직 금지.
[완료 기준] npm run dev로 / 와 /admin/login 이 빈 화면으로 뜬다. 0.0.0.0:3000.
[검증] 만든 폴더 트리를 보여 주고, 내가 직접 확인할 명령을 적어. 커밋하고 멈춰.
```

**낙관적 잠금**
```
[목표] settings 저장에 ARCHITECTURE.md 6-2 낙관적 잠금을 적용한다.
[제약] 비관적 잠금 금지. 409 응답에 현재 version, updated_by, updated_at 포함. 감사 로그 기록.
[완료 기준] 같은 version으로 동시 PUT 2개 → 200 하나, 409 하나.
[검증] 6-6의 curl 절차를 VERIFY.md에 추가해. 실행은 내가 한다. 커밋하고 멈춰.
```

**스냅샷 + 캐시**
```
[목표] 게시 시 data/snapshots/v{N}.json, latest.json을 원자적으로 쓰고, 조회 API는 스냅샷을 먼저 읽는다.
       사용자 화면은 lastResultAtom(atomWithStorage)에 마지막 결과를 저장하고, 실패 시 저장본 + 기준 시각 배너.
[제약] public/에 쓰지 않는다. 캐시에는 toUserDto 필드만. 다른 조회키로 조회하면 이전 캐시 삭제.
[완료 기준] DB 파일 이름을 임시로 바꿔도 조회 성공 / 서버를 끄면 열려 있던 화면에 저장본 배너.
[검증] 두 장애를 만드는 방법과 기대 화면을 VERIFY.md에 추가해. 커밋하고 멈춰.
```

**경계 위반 점검 (검토 세션에서)**
```
코드를 고치지 말고 ARCHITECTURE.md 2장 의존 규칙 위반을 찾아 표로 보고해:
위 층 import, 같은 층 슬라이스 간 import, 클라이언트 컴포넌트의 server/ import, 라우트 파일 안의 로직.
```

---

## 13. 서술형 연결

| 질문 | 답의 뼈대 (구조에서 가리킬 곳) |
|---|---|
| 업로드·계산·조회의 책임을 어떻게 나눴나? | `server/import` / `core` / `publish` / `read` 4분할, 라우트는 얇게, 조회는 게시본만 → 계산이 실패해도 조회 영향 없음, core 단독 테스트 |
| 관리자 여러 명이 동시에 수정하면? | settings `version` 낙관적 잠금(409 + 충돌 안내), 재계산은 활성 작업 유니크 인덱스로 하나만, 게시는 `BEGIN IMMEDIATE` + 입력 버전 재확인, 감사 로그 |
| 사용자가 보는 중에 서버가 죽으면? | 게시 스냅샷(DB 장애와 분리) + 클라이언트 캐시(기준 시각 배너), 프로세스 전체 다운 새로고침은 한계 → 서비스 워커·외부 정적 호스팅이 대안 |
| 관리자와 사용자를 어떻게 분리했나? | 라우트·API 네임스페이스·서버 모듈·응답 DTO 4곳, 미들웨어 + 핸들러 2단 권한 확인 |
| 남의 정보가 보이지 않게 했나? | 본인 확인, `toUserDto()` 화이트리스트, 공용 PC 캐시 정책 |
| 왜 Jotai(전역 상태)를 썼나? | 서버 데이터가 아니라 화면 상태와 오프라인 캐시에만, 범위는 features/model |
| 데이터가 10배가 되면? | 계산은 작업 큐에서 게시 시점에만, 조회는 스냅샷 읽기라 영향 작음, metrics의 계산 시간으로 측정 |
