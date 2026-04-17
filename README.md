# 아맞당 (Amatdang)

<img width="1080" alt="amatdang_banner" src="https://github.com/user-attachments/assets/2c830682-cb8e-47bf-bade-d0b98f9d2a20" />

### [📱 앱 설치하러 가기](https://apps.apple.com/kr/app/%EC%95%84%EB%A7%9E%EB%8B%B9-%EC%B9%B4%ED%8E%98-%EC%9D%8C%EB%A3%8C-%EB%8B%B9%EB%A5%98-%EA%B8%B0%EB%A1%9D/id6748367287)

> 카페 음료 속 당류를 가장 귀엽게 관리하는 법, **아맞당**

### 주요 기능
- 간편 기록 — 카페 음료 섭취 & 당류 기록
- 맞춤 목표 — 개인별 당류 섭취 목표 설정 및 달성 관리
- 음료 정보 — 프랜차이즈 카페 메뉴별 당류 정보 조회

# ⚙️ 개발환경 및 기술스택

- **Minimum Deployment**: iOS 18.0
- **Swift Version**: 6.0
- **Dependency Manager**: SPM (Tuist 통합)
- **Project Generator**: Tuist 4.48.2
- **Architecture**: SwiftUI · `@Observable` 기반 MVVM · `swift-dependencies` 1.9.2 DI · Swift Concurrency · Clean Architecture
- **Networking**: Alamofire 5.10.2
- **Local Persistence**: SwiftData (iOS 17+)
- **Authentication**: Apple Sign-In · Auth0.swift 2.14.0
- **Analytics**: Amplitude-Swift 1.15.0
- **Push Notifications**: Firebase iOS SDK 12.3.0 (Messaging)
- **Testing**: Swift Testing
- **3rd Party**: Lottie 4.5.2 · Nuke (NukeUI) · Swift Async Algorithms 1.0.4

# 🧩 모듈 구조

![모듈 의존성 그래프](./HumanNeverDie/graph.png)

**Tuist 기반 멀티 모듈 구조**에 **`swift-dependencies` 기반 `@DependencyClient` struct-of-closures 패턴**을 적용하여 Clean Architecture(Domain · Data · Feature) 레이어 분리

- **App (AMatDang)** — 앱 타겟
- **RootFeature** — Composition Root. 전체 DI 의존성 조립
- **Features** — SwiftUI `@Observable` ViewModel 기반 Feature 레이어
- **CommonFeature / DesignSystem** — 공용 UI 컴포넌트 및 디자인 시스템
- **Domain** — UseCase · RepositoryInterface 선언 및 .live 팩토리
- **Data** — Repository .live 구현 (네트워크·로컬DB·Apple 로그인)
  - **BaseNetwork** — Alamofire 기반 네트워크 추상화
  - **LocalDataBase** — SwiftData 기반 로컬 저장소
- **Shared / ThirdParty** — 공용 모델·에러·플랫폼 클라이언트 프로토콜
