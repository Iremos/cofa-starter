# Design System Inspired by SK hynix

> SK hynix 공개 CI(컬러 시스템)를 바탕으로, **사내 업무용 웹 도구**(조회 화면, 관리자 화면, 데이터 표)에 맞게 재해석한 디자인 규칙입니다.
> 공식 디자인 시스템이 아니며, 공개된 CI 색상값 외의 브랜드 자산(로고, 심볼, 전용 서체)은 사용하지 않습니다. 서체는 오픈 라이선스(SIL OFL 1.1)인 Pretendard GOV를 프로젝트에 포함해 씁니다.

## 1. Visual Theme & Atmosphere

SK hynix의 화면은 **정밀한 반도체 공정처럼 정돈되고 신뢰감 있는 업무 도구**로 읽혀야 한다. 바탕은 순백(`#FFFFFF`)과 아주 옅은 쿨그레이(`#F5F6F8`)의 두 단계로만 나뉘고, 그 위에 정보가 표와 카드로 질서 있게 놓인다. 마케팅 사이트처럼 여백으로 분위기를 만드는 대신, **숫자와 상태가 첫눈에 들어오는 밀도**를 우선한다.

브랜드의 존재감은 면적이 아니라 **선과 점**으로 드러낸다. 화면 맨 위의 얇은 **SK Red → SK Orange 그라데이션 띠**(4px)가 유일한 장식이며, 이것이 CI의 "행복날개" 색 흐름을 상징한다. 나머지 화면에서 브랜드 빨강은 아껴 쓴다. 업무 도구에서 빨강은 "위험"과 겹치기 때문이다. 대신 깊은 **SK Navy**가 헤더, 주요 버튼, 제목을 맡아 기업의 무게감과 차분함을 만든다.

서체는 **Pretendard GOV** 하나로 통일한다. 서체 파일을 프로젝트 안에 두고(self-host) 직접 제공하므로, 운영체제가 달라도 같은 모양으로 보이고 사내망·오프라인 환경에서도 깨지지 않는다. 숫자는 **고정폭 숫자(tabular-nums)**로 정렬해 표에서 자릿수가 흔들리지 않게 한다.

**Key Characteristics:**
- 흰색 + 옅은 쿨그레이 두 단계 바탕, 장식 없는 정돈된 업무 화면
- 화면 상단 4px **SK Red → SK Orange 그라데이션 띠**가 유일한 브랜드 장식
- 주요 행동(버튼, 활성 탭, 링크 강조)은 **SK Navy**, 빨강은 브랜드 띠와 위험 상태에만
- 상태는 CI 보조색에서 파생한 의미 색 + **반드시 글자 라벨**을 함께 표시
- 8px 그리드, 중간 반경(6~8px), 그림자 최소, 구분은 테두리로
- 표 중심 레이아웃, 고정폭 숫자, 기준 시각과 데이터 출처를 항상 노출
- Pretendard GOV를 프로젝트에 포함(self-host)해 모든 환경에서 같은 서체, 실행 중 외부 CDN 호출 없음
- UI 라이브러리 없이 순수 CSS로 구현 가능

## 2. Color Palette & Roles

> 출처: SK hynix 기업정보 > Brand > CI 페이지의 컬러 시스템. CI 규정상 색상 체계는 "엄격하게 준수"해야 하므로, 아래 **CI 원색 값은 바꾸지 않는다.** 글자 대비가 부족한 경우에만 같은 색상 계열의 **파생 톤**(어둡게 또는 옅게)을 정의해 쓴다.

### Primary
- **SK Red** (`#EA002C`, PANTONE 186 C): CI 대표색. 상단 브랜드 띠, 서비스명 옆 작은 점, **위험 상태**에만 쓴다. 흰 바탕 대비 4.63:1로 큰 글자·아이콘에는 쓸 수 있지만, 본문 글자에는 파생 톤 `#C40024`를 쓴다.
- **SK Orange** (`#F47725`, PANTONE 158 C): CI 대표색. 브랜드 띠 그라데이션의 끝색, **주의 상태**의 기준색. 흰 바탕 대비 2.80:1이라 **글자색으로 쓰지 않는다.** 글자에는 파생 톤 `#B4500F`.

### Secondary & Accent
- **SK Navy** (`#0E306D`, PANTONE 288 C): 시스템의 **주 행동색**. 헤더 배경, 주요 버튼, 활성 탭 밑줄, 제목 강조. 흰 글자 대비 12.63:1.
- **SK Blue** (`#0072C6`, PANTONE 300 C): 링크, 포커스 링, 정보 안내. 흰 바탕 대비 4.97:1.
- **SK Teal** (`#009A93`, PANTONE 3275 C): **정상 상태**의 기준색. 글자에는 파생 톤 `#00756F`.
- **SK Purple** (`#68127A`, PANTONE 526 C): **확인 필요 상태**(데이터 이상, 실사 중, 검토 대기). 신호등 색과 겹치지 않아 "판단 보류"를 구분하기 좋다. 흰 바탕 대비 10.74:1.
- **SK Yellow** (`#FBBC05`, PANTONE 7408 C), **SK Green** (`#B3CF0A`, PANTONE 2292 C): 흰 바탕 대비가 매우 낮아(1.7:1대) 글자·테두리로 쓰지 않는다. 표가 아닌 범례·작은 표식 채움에만 제한적으로 쓰며, 그 위 글자는 진한 잉크색.

### Surface & Background
- **SK White** (`#FFFFFF`): 카드, 표, 입력창, 모달의 바탕.
- **Canvas Gray** (`#F5F6F8`): 페이지 바탕. 카드가 그 위에 한 단계 떠 보이게 한다.
- **Subtle Gray** (`#EEF0F3`): 표 머리행, 선택된 행, 비활성 영역.
- **Header Navy** (`#0E306D`): 상단 헤더 바탕. 그 바로 위에 4px 브랜드 띠.

### Neutrals & Text
- **Ink** (`#1A1D24`): 제목과 본문 글자. 순수 검정(`#000000`, SK Black)은 큰 면적에 쓰지 않는다.
- **Muted** (`#5B6170`): 보조 설명, 표 머리글, 기준 시각 표기. 흰 바탕 대비 6.20:1.
- **Subtle** (`#6B7280`): 플레이스홀더, 비활성 글자. 흰 바탕 대비 4.83:1 (이보다 옅게 쓰지 않는다).
- **Border** (`#D9DDE3`): 카드·표·입력창 테두리.
- **Divider** (`#E6E9ED`): 표 행 구분선.

### Semantic & Accent

| 상태 | 기준색 (CI) | 배지 바탕 | 배지 글자 | 대비 | 라벨 예 |
|---|---|---|---|---|---|
| 정상 | SK Teal `#009A93` | `#E5F4F3` | `#00756F` | 4.92:1 | 정상 |
| 주의 | SK Orange `#F47725` | `#FEF0E6` | `#B4500F` | 4.60:1 | 부족, 지연 |
| 위험 | SK Red `#EA002C` | `#FDE6EA` | `#C40024` | 5.24:1 | 품절, 오류, 초과 |
| 확인 필요 | SK Purple `#68127A` | `#F1E7F3` | `#68127A` | 8.93:1 | 확인 필요, 검토 대기 |
| 정보 | SK Navy `#0E306D` | `#E6F0F9` | `#0E306D` | 10.95:1 | 안내, 초안 |
| 경고 배너 (오래된 데이터) | SK Yellow `#FBBC05` | `#FFF6DB` | `#8A6100` | 5.13:1 | ○○ 기준 저장본 |

- 상태는 **색 + 글자 라벨 + (선택) 아이콘**으로 표시한다. 색만으로 구분하지 않는다.
- 모든 배지 조합은 WCAG AA(4.5:1) 이상이다.

### Gradient System
- **Brand Stripe**: `linear-gradient(90deg, #EA002C 0%, #F47725 100%)`, 높이 4px, 화면 최상단 전체 폭.
- 그 외 버튼, 카드, 배경, 차트에는 그라데이션을 쓰지 않는다. 브랜드 띠가 유일한 그라데이션이어야 그 의미가 산다.

## 3. Typography Rules

### Font Family
- **Primary**: `"Pretendard GOV"` (SIL OFL 1.1, 프로젝트에 포함해 제공)
- **Fallback (파일을 못 불러올 때)**: `-apple-system, BlinkMacSystemFont, system-ui, "Apple SD Gothic Neo", "Malgun Gothic", "Noto Sans KR", sans-serif`
  - 시스템 서체는 이름만 지정해 사용자 기기에 설치된 것을 쓰는 방식이라 별도 라이선스가 필요 없다. 시스템 서체 파일을 복사해 넣지 않는다.
- **Monospace (코드·ID·로그)**: `ui-monospace, SFMono-Regular, Menlo, Consolas, "D2Coding", monospace`
- 쓰는 굵기는 **400 / 600 / 700 세 가지만** 포함한다 (파일 1개당 약 2MB, 합계 약 6MB).

### Font Loading (self-host)

실행 중에 CDN에서 불러오지 않는다. 작업 시작 시 **공개 GitHub 저장소에서 파일을 한 번 받아 프로젝트에 넣는다.**

```bash
mkdir -p public/fonts
BASE=https://raw.githubusercontent.com/orioncactus/pretendard/v1.3.9
for w in Regular SemiBold Bold; do
  curl -fsSL -o public/fonts/PretendardGOV-$w.woff2 \
    "$BASE/packages/pretendard-gov/dist/web/static/woff2/PretendardGOV-$w.woff2"
done
curl -fsSL -o public/fonts/OFL.txt "$BASE/LICENSE"   # OFL은 배포 시 라이선스 동봉이 조건
```

```css
@font-face { font-family: "Pretendard GOV"; font-weight: 400; font-style: normal; font-display: swap;
  src: local("Pretendard GOV Regular"), url("/fonts/PretendardGOV-Regular.woff2") format("woff2"); }
@font-face { font-family: "Pretendard GOV"; font-weight: 600; font-style: normal; font-display: swap;
  src: local("Pretendard GOV SemiBold"), url("/fonts/PretendardGOV-SemiBold.woff2") format("woff2"); }
@font-face { font-family: "Pretendard GOV"; font-weight: 700; font-style: normal; font-display: swap;
  src: local("Pretendard GOV Bold"), url("/fonts/PretendardGOV-Bold.woff2") format("woff2"); }
```

- 경로 `/fonts/...`는 정적 파일 폴더 기준이다 (Next.js는 `public/`, 순수 Node 서버는 정적 제공 폴더). 프레임워크에 맞게 조정한다.
- **파일을 받을 수 없으면**(네트워크 차단 등) 시도하지 말고 바로 Fallback 스택으로 진행한다. `font-display: swap`과 Fallback 덕분에 화면은 깨지지 않는다.
- CDN `@import`(`cdn.jsdelivr.net` 등)는 쓰지 않는다. 사내망·차단 환경에서 요청이 실패하거나 지연되고, 외부 호출이 생긴다.

### Hierarchy

| Role | Size | Weight | Line Height | Letter Spacing | Notes |
|---|---|---|---|---|---|
| Page title (H1) | 24px | 700 | 32px | -0.01em | 화면당 하나. 헤더 아래 첫 줄 |
| Section (H2) | 20px | 700 | 28px | -0.01em | 카드·패널 묶음 제목 |
| Card title (H3) | 16px | 700 | 24px | normal | 카드, 결과 항목 제목 |
| Body | 16px | 400 | 24px | normal | 기본 본문 (태블릿·현장 사용 고려해 15px 이하로 내리지 않음) |
| Body small | 14px | 400 | 20px | normal | 보조 설명, 기준 시각, 표 셀 |
| Table header | 14px | 600 | 20px | normal | Muted 색, Subtle Gray 바탕 |
| Label / Badge | 13px | 600 | 18px | 0.01em | 상태 배지, 폼 라벨 |
| Key number | 28px | 700 | 32px | -0.01em | 요약 숫자 (tabular-nums) |
| Button | 16px | 600 | 20px | normal | |

### Principles
- **숫자는 고정폭**: 표와 요약 숫자에는 `font-variant-numeric: tabular-nums`. 자릿수가 세로로 정렬되어야 비교가 빠르다.
- **굵기는 3단계만**: 400(본문), 600(라벨·버튼·표 머리), 700(제목·핵심 숫자).
- **대문자·자간 확대 강조 없음**: 한글 업무 화면에서는 크기와 굵기로만 위계를 만든다.
- **단위는 숫자 옆에 작게**: `18` + `개`(Body small, Muted). 단위가 숫자보다 크거나 굵지 않게.
- **기준 시각과 출처는 항상 Body small + Muted**로 제목 바로 아래에 둔다.

### Note on Font Substitutes
- SK 전용 서체는 라이선스를 확인할 수 없어 쓰지 않는다. Pretendard GOV는 SIL OFL 1.1이라 프로젝트에 포함·배포할 수 있다 (라이선스 파일 동봉, 서체 파일 자체를 수정해 같은 이름으로 배포하지 않을 것).
- Pretendard GOV를 못 불러오면 Fallback 스택이 Windows(맑은 고딕), macOS(애플 SD 고딕 Neo), Linux(Noto Sans KR)로 대체한다.
- 서체가 바뀌어도 위계는 **크기·굵기·색**으로 유지된다.

## 4. Component Stylings

### Buttons

**Primary — Navy Solid**
- Background: SK Navy (`#0E306D`) / Text: White / Border: none
- Radius: 6px / Height: 48px (모바일·태블릿 터치) 또는 40px (데스크톱 밀집 영역) / Padding: 0 20px
- Hover: `#0A2552` / Focus: 3px SK Blue 링 (`outline: 3px solid #0072C6; outline-offset: 2px`) / Disabled: `#C5CAD3` 바탕, White 글자
- Use for: 화면당 하나의 핵심 행동 (검색, 저장, 게시)

**Secondary — Outlined**
- Background: White / Text: SK Navy / Border: 1px solid `#0E306D`
- Radius: 6px / Height: Primary와 동일
- Use for: 보조 행동 (취소, 미리보기, 내보내기)

**Danger — Red Outlined**
- Background: White / Text: `#C40024` / Border: 1px solid `#C40024`
- 확정 시 확인 단계(모달)를 거친다. 꽉 찬 빨강 버튼은 쓰지 않는다.
- Use for: 삭제, 되돌리기, 게시 취소

**Ghost — Text Button**
- Background: transparent / Text: SK Blue (`#0072C6`) / 밑줄은 hover 시
- Use for: 표 안의 행 단위 행동 (상세, 이력 보기)

### Cards & Containers

**Panel Card**
- Background: White / Border: 1px solid `#D9DDE3` / Radius: 8px / Padding: 24px (모바일 16px)
- Header: H3 제목 + 오른쪽 정렬 보조 행동 / 제목 아래 Body small Muted로 기준 시각·출처
- Shadow: 없음

**Summary Stat Card**
- Panel Card 구조, 내용은 라벨(Body small, Muted) → 핵심 숫자(Key number) → 변화·상태 배지
- 3~4개를 한 줄에 배치, 모바일에서는 2열

**Result Item Card (조회 결과)**
- 왼쪽: 이름(H3) + 보조 정보(Body small) / 오른쪽: 핵심 숫자 + 상태 배지
- 아래: 세부 정보 행 (예: 위치별 수량) — Divider로 구분
- 위험·확인 필요 항목은 카드 왼쪽에 4px 상태색 세로선 (`border-left`)

**Status Badge**
- Radius: 999px / Padding: 2px 10px / Label 13px 600
- 색은 2장 Semantic 표를 그대로 따른다. 배지 안 글자는 항상 상태 이름

**Banner (화면 상단 알림)**
- 전체 폭, Radius 8px, Padding 12px 16px, 왼쪽 4px 상태색 선
- 정보(Navy) / 경고(Yellow 파생) / 오류(Red 파생) 3종
- 용도: 오래된 데이터, 검증 실패, 저장 충돌, 서버 연결 끊김

### Inputs & Forms

**Text Input / Select**
- Height: 48px / Radius: 6px / Border: 1px solid `#D9DDE3` / Padding: 0 14px / 글자 16px
- Focus: Border `#0072C6` + 3px `rgba(0,114,198,0.25)` 링
- Error: Border `#C40024` + 입력창 바로 아래 Body small `#C40024` 메시지 (무엇이 왜 틀렸는지)
- Label: 입력창 위, Label 13px 600 Ink. 플레이스홀더로 라벨을 대신하지 않는다

**Search Bar (조회 화면)**
- 화면 상단 큰 입력창(높이 56px, 글자 18px) + 오른쪽 Primary 버튼
- 입력창 아래 예시 문구(Body small, Muted): "예: EQ-A05, 오링 120"
- Enter로 검색, 빈 값 제출 시 안내만 표시하고 요청하지 않는다

**File Upload Panel (관리자)**
- 점선 테두리(`2px dashed #D9DDE3`) 영역 + "파일 선택" Secondary 버튼
- 업로드 후 즉시 **검증 결과 목록** 표시: 통과 행 수 / 거부 행 수 / 거부 사유별 행 번호
- 검증 통과 전에는 반영(게시) 버튼 비활성

**Conflict / Confirm Dialog**
- 중앙 모달, 폭 480px, Radius 8px, Padding 24px, 배경 딤 `rgba(26,29,36,0.45)`
- 저장 충돌(다른 사용자가 먼저 수정): 제목 "다른 사용자가 먼저 수정했습니다" + 변경 시각·수정자 + [최신 내용 불러오기](Primary) [내 변경 복사 후 닫기](Secondary)

### Navigation

**App Header**
- 최상단 4px Brand Stripe → 그 아래 높이 56px SK Navy 헤더
- 왼쪽: 서비스명(16px 700 White) + 작은 SK Red 점(6px 원) / 오른쪽: 역할 표시("관리자"·"사용자"), 기준 시각
- 로고 이미지나 심볼은 임의로 그리거나 재현하지 않는다. 텍스트 서비스명만 쓴다

**Admin Tabs**
- 헤더 아래 흰 바탕 탭 줄, 탭 높이 48px, 글자 15px 600
- 활성 탭: SK Navy 글자 + 3px SK Navy 밑줄 / 비활성: Muted 글자
- 관리자 화면 탭 구성 예: 데이터 업로드 · 규칙 설정 · 미리보기 · 게시 · 변경 이력

**Mobile**
- 헤더 높이 52px, 서비스명 + 역할만. 탭은 가로 스크롤 가능한 한 줄 (페이지 자체는 가로 스크롤 금지)

### Data Display (표와 상태)

**Data Table**
- 머리행: Subtle Gray(`#EEF0F3`) 바탕, Table header 스타일, 상단 고정(sticky)
- 행 높이 48px, 구분선 Divider, hover 시 `#F5F6F8`
- 숫자 열은 오른쪽 정렬 + tabular-nums, 텍스트 열은 왼쪽 정렬, 상태 열은 배지
- 모바일에서 표는 **카드 목록으로 전환**하거나 표 영역만 가로 스크롤

**Screen States (모든 데이터 화면에 필수)**

| 상태 | 표시 |
|---|---|
| 로딩 | 결과 영역에 회색 자리 표시줄 3개 + "불러오는 중" (Body small) |
| 결과 없음 | 가운데 정렬 안내문 + 다음 행동 ("검색어를 확인하거나 담당자에게 문의하세요") |
| 오류 | 오류 배너 + 원인 한 줄 + [다시 시도] Secondary |
| 오래된 데이터 | 경고 배너 "○○ 기준 저장된 결과입니다. 서버에 연결할 수 없어 최신이 아닐 수 있습니다." |
| 권한 없음 | 안내문 "이 화면은 관리자만 볼 수 있습니다." + 사용자 화면으로 가는 링크 |

**Timestamp & Source Line**
- 모든 데이터 화면 제목 아래: "기준: YYYY-MM-DD HH:MM · 출처: (데이터 파일·시스템명)" (Body small, Muted)

### Footer
- 사내 도구는 큰 푸터를 두지 않는다
- 페이지 맨 아래 Body small Muted 한 줄: 서비스명 · 문의처(부서명) · 데이터 갱신 주기

## 5. Layout Principles

### Spacing System
- **Base unit**: 8px (세밀한 정렬에 4px 허용)
- **Scale**: 4 / 8 / 12 / 16 / 24 / 32 / 48
- 카드 내부 24px, 카드 사이 16px, 섹션 사이 32px, 페이지 좌우 여백 24px (모바일 16px)

### Grid & Container
- **Max content width**: 1200px 중앙 정렬
- **사용자 조회 화면**: 단일 열, 최대 폭 800px (검색 → 결과 목록)
- **관리자 화면**: 왼쪽 작업 영역(2/3) + 오른쪽 검증·미리보기 패널(1/3). 1024px 미만에서 세로로 쌓기
- **전체 보기 화면**: 요약 카드 한 줄 + 필터 줄 + 전체 폭 표

### Whitespace Philosophy
여백은 분위기가 아니라 **그룹 구분**을 위해 쓴다. 같은 일에 속한 요소는 8~12px, 다른 일은 24~32px로 떨어뜨린다. 화면 한 장에서 사용자가 해야 할 일이 위에서 아래로 한 번에 읽혀야 한다: **무엇을 보는가(제목·기준 시각) → 무엇을 할 수 있는가(검색·필터·행동) → 결과(표·카드)**.

### Border Radius Scale

| Radius | Use |
|---|---|
| 4px | 체크박스, 작은 태그 |
| 6px | 버튼, 입력창 |
| 8px | 카드, 패널, 배너, 모달 |
| 999px | 상태 배지, 원형 표식 |

중간 반경(6~8px)으로 통일한다. 큰 둥근 모서리(20px 이상)는 쓰지 않는다. 업무 화면의 정돈된 인상을 해친다.

## 6. Depth & Elevation

| Level | Treatment | Use |
|---|---|---|
| 0 | 그림자 없음, 1px 테두리 | 기본. 카드, 표, 입력창 (95% 이상) |
| 1 | `0 1px 2px rgba(16,24,40,0.06)` | 상단 고정 헤더, 고정 표 머리 |
| 2 | `0 8px 24px rgba(16,24,40,0.12)` | 모달, 드롭다운, 토스트 |

### Shadow Philosophy
깊이는 그림자가 아니라 **바탕색 두 단계(Canvas Gray ↔ White)와 테두리**로 만든다. 그림자는 화면 위에 "떠 있는 것"(모달, 드롭다운)에만 쓴다.

### Decorative Depth
- 장식은 상단 Brand Stripe 하나뿐이다. 배경 패턴, 일러스트, 반도체 회로 무늬 등을 넣지 않는다.

## 7. Do's and Don'ts

### Do
- 화면 최상단에 4px SK Red → SK Orange Brand Stripe를 둔다
- 주요 행동은 SK Navy, 링크와 포커스는 SK Blue로 일관되게
- CI 원색 값은 그대로 쓰고, 글자 대비가 부족할 때만 같은 계열의 파생 톤을 쓴다
- 상태는 색 + 글자 라벨로 표시하고, "확인 필요"는 SK Purple로 신호등 색과 구분한다
- 모든 데이터 화면에 기준 시각과 출처를 표시한다
- 로딩·결과 없음·오류·오래된 데이터·권한 없음 5가지 상태를 모두 설계한다
- 숫자는 오른쪽 정렬 + tabular-nums
- 터치 대상은 최소 44px, 현장·태블릿 화면은 48px
- 서체는 Pretendard GOV(self-host, 400/600/700) + Fallback 스택, 스타일은 순수 CSS로 구현한다

### Don't
- SK Red를 주요 버튼이나 넓은 면적에 쓰지 않는다 (위험 상태와 혼동)
- SK Orange, Yellow, Green을 흰 바탕 위 글자색으로 쓰지 않는다 (대비 부족)
- 로고·심볼을 SVG나 CSS로 임의 재현하지 않는다
- CI 색상값을 임의로 보정하거나 비슷한 색으로 대체하지 않는다
- 그라데이션을 Brand Stripe 외에 쓰지 않는다
- 실행 중 외부 CDN(서체 `@import` 포함), UI·차트 라이브러리를 불러오지 않는다
- 시스템 서체 파일(맑은 고딕, 애플 SD 고딕 Neo 등)을 프로젝트에 복사하지 않는다
- 색만으로 상태를 구분하지 않는다
- 20px 이상 둥근 모서리, 큰 그림자, 애니메이션 장식을 쓰지 않는다
- 민감 정보(단가, 주소, 개인 연락처 등)를 화면에서 CSS로 숨기는 방식으로 처리하지 않는다 (서버 응답에서 제거)

## 8. Responsive Behavior

### Breakpoints

| Name | Width | Key Changes |
|---|---|---|
| Mobile | ≤ 767px | 단일 열, 좌우 여백 16px, 요약 카드 2열, 표 → 카드 목록, 헤더 52px |
| Tablet | 768–1023px | 단일 열 또는 2열, 관리자 화면 패널 세로 쌓기, 버튼 48px 유지 |
| Desktop | ≥ 1024px | 관리자 2/3 + 1/3 분할, 표 전체 폭, 밀집 영역 버튼 40px 허용 |
| Wide | ≥ 1440px | 콘텐츠 최대 폭 1200px 고정, 여백만 증가 |

### Touch Targets
- 모든 클릭 대상 최소 44×44px. 현장·태블릿·장갑 사용 환경에서는 48px 이상, 대상 간 간격 8px 이상.

### Collapsing Strategy
- **표**: 768px 미만에서 행마다 카드로 전환 (핵심 숫자와 상태 배지를 카드 오른쪽 위에)
- **관리자 분할**: 1024px 미만에서 작업 영역 → 검증·미리보기 순서로 세로 쌓기
- **탭**: 좁은 폭에서 한 줄 가로 스크롤 (페이지 자체는 가로 스크롤 금지)
- **요약 카드**: 4열 → 2열

### Image Behavior
- 업무 화면에 장식 이미지를 쓰지 않는다. 필요한 경우(장비 사진 등) 4:3 비율, Radius 8px, 고정 크기 썸네일

## 9. Agent Prompt Guide

### Quick Color Reference
- Brand stripe: "`linear-gradient(90deg, #EA002C, #F47725)` 4px, 화면 최상단"
- Primary action: "SK Navy (`#0E306D`) 바탕, 흰 글자"
- Link / Focus: "SK Blue (`#0072C6`)"
- Page background: "Canvas Gray (`#F5F6F8`)"
- Card / Table background: "White (`#FFFFFF`), 테두리 `#D9DDE3`"
- Text: "Ink (`#1A1D24`)", Muted: "`#5B6170`"
- 정상: "바탕 `#E5F4F3` / 글자 `#00756F`"
- 주의: "바탕 `#FEF0E6` / 글자 `#B4500F`"
- 위험: "바탕 `#FDE6EA` / 글자 `#C40024`"
- 확인 필요: "바탕 `#F1E7F3` / 글자 `#68127A`"
- 오래된 데이터 배너: "바탕 `#FFF6DB` / 글자 `#8A6100`"

### CSS Tokens

```css
:root {
  /* CI 원색 (변경 금지) */
  --sk-red: #EA002C;
  --sk-orange: #F47725;
  --sk-navy: #0E306D;
  --sk-blue: #0072C6;
  --sk-teal: #009A93;
  --sk-purple: #68127A;
  --sk-yellow: #FBBC05;

  /* 바탕·글자 */
  --bg-canvas: #F5F6F8;
  --bg-surface: #FFFFFF;
  --bg-subtle: #EEF0F3;
  --text: #1A1D24;
  --text-muted: #5B6170;
  --text-subtle: #6B7280;
  --border: #D9DDE3;
  --divider: #E6E9ED;

  /* 상태 (배지 바탕 / 글자) */
  --ok-bg: #E5F4F3;      --ok-fg: #00756F;
  --warn-bg: #FEF0E6;    --warn-fg: #B4500F;
  --danger-bg: #FDE6EA;  --danger-fg: #C40024;
  --check-bg: #F1E7F3;   --check-fg: #68127A;
  --info-bg: #E6F0F9;    --info-fg: #0E306D;
  --stale-bg: #FFF6DB;   --stale-fg: #8A6100;

  --brand-stripe: linear-gradient(90deg, var(--sk-red) 0%, var(--sk-orange) 100%);

  --radius-sm: 4px;  --radius-md: 6px;  --radius-lg: 8px;  --radius-pill: 999px;
  --space-1: 4px; --space-2: 8px; --space-3: 12px; --space-4: 16px; --space-5: 24px; --space-6: 32px; --space-7: 48px;
  --tap: 48px;

  --font-sans: "Pretendard GOV", -apple-system, BlinkMacSystemFont, system-ui, "Apple SD Gothic Neo", "Malgun Gothic", "Noto Sans KR", sans-serif;
  --font-mono: ui-monospace, SFMono-Regular, Menlo, Consolas, "D2Coding", monospace;
}
```

### Example Component Prompts
- "DESIGN.md의 Font Loading 절차대로 Pretendard GOV 400/600/700과 OFL.txt를 public/fonts에 받고 @font-face를 추가해. 받지 못하면 시도하지 말고 Fallback 스택으로 진행하고 알려 줘."
- "DESIGN.md의 App Header를 만들어. 최상단 4px Brand Stripe, 그 아래 56px SK Navy 헤더, 왼쪽에 서비스명(흰색 16px 700)과 6px SK Red 점, 오른쪽에 역할 표시와 기준 시각(Body small). 로고 이미지는 쓰지 마."
- "사용자 조회 화면을 만들어. 최대 폭 800px 단일 열. 56px 높이 검색창 + 오른쪽 Primary 버튼, 아래 예시 문구. 결과는 Result Item Card 목록이고, 위험·확인 필요 항목은 왼쪽 4px 상태색 선과 함께 목록 위쪽에 정렬. Screen States 5가지를 모두 구현해."
- "관리자 화면의 데이터 업로드 탭을 만들어. 왼쪽 2/3에 File Upload Panel, 오른쪽 1/3에 검증 결과(통과 행 수, 거부 행 수, 사유별 행 번호). 검증 통과 전에는 [게시] Primary 버튼 비활성. 1024px 미만에서 세로로 쌓기."
- "전체 보기 화면을 만들어. 요약 Stat Card 4개(라벨, 핵심 숫자 tabular-nums, 상태 배지) → 필터 줄 → Data Table(머리행 sticky, 숫자 열 오른쪽 정렬, 상태 열 배지). 768px 미만에서 표를 카드 목록으로 전환."
- "저장 충돌 시 Conflict Dialog를 띄워. 제목 '다른 사용자가 먼저 수정했습니다', 변경 시각과 수정자, [최신 내용 불러오기] Primary, [내 변경 복사 후 닫기] Secondary."

### Iteration Guide
1. 한 번에 한 화면, 한 컴포넌트만 고친다
2. 색은 이름과 HEX를 함께 지정한다 ("SK Navy `#0E306D`")
3. 새 색이 필요하면 CI 색 중에서 고르고, 대비가 부족하면 파생 톤을 만들어 이 문서에 추가한 뒤 쓴다
4. 화면 상태 5종 중 빠진 것이 없는지 먼저 확인한다
5. 담당자가 말한 사용 환경(태블릿, 야간, 장갑 등)이 이 문서의 기본값보다 우선한다
6. 애매하면 덜 꾸민 쪽을 고른다

### Known Gaps
- 공식 CI 페이지에 HEX와 RGB가 서로 다르게 표기된 색이 있다 (SK Orange: HEX `#F47725` / RGB 255,122,0, SK Yellow: HEX `#FBBC05` / RGB 251,188,55, SK Green: HEX `#B3CF0A` / RGB 155,207,10). 이 문서는 **웹 사용을 전제로 HEX 값**을 기준으로 했다.
- CI 페이지에 전용 서체 안내가 없어, 오픈 라이선스 서체 Pretendard GOV(v1.3.9)를 쓴다. 굵기 3종 woff2 합계 약 6MB라 첫 로딩이 느릴 수 있다. 더 줄이려면 서브셋 파일을 만들 수 있지만 이 문서 범위 밖이다.
- 파생 톤(`#C40024`, `#B4500F`, `#00756F`, `#8A6100` 등)과 중립색은 CI에 없는 값으로, 글자 대비(WCAG AA)를 맞추기 위해 이 문서에서 정의했다.
- 로고·심볼 사용 규정(여백 0.5X 등)은 실제 로고를 쓰는 경우에만 해당하며, 이 문서는 로고를 쓰지 않는 것을 기본으로 한다.
