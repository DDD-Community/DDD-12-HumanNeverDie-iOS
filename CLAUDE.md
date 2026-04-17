# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Tooling

- **Tuist 4.48.2** (pinned in `HumanNeverDie/mise.toml`) generates the Xcode workspace. Do not hand-edit generated `.xcodeproj`/`.xcworkspace` files.
- **Swift Dependencies** (swift-dependencies) is the DI framework. No Needle/Swinject.
- **iOS deployment target: 18.0**, iPhone-only. Korean (`ko`) is the development region; all Project options set 2-space indent (no tabs).

## Common commands

Run from `HumanNeverDie/` directory.

| Task | Command |
|------|---------|
| Full clean + install + generate + open Xcode | `make install` |
| Regenerate and open workspace | `make generate` |
| Generate without opening Xcode | `make generate_no_open` |
| Resolve SPM packages | `make fetch` (= `tuist install`) |
| Clean derived/generated projects | `make clean` |
| Edit Tuist manifests in Xcode | `make edit` |
| Scaffold new Feature module (interactive) | `make feature` |
| Scaffold new Domain module (interactive) | `make domain` |
| Toggle dev build (dynamic frameworks for faster builds) | `ISDEV=true make generate` |

`make feature` / `make domain` call `tuist scaffold` and then run `scripts/add_feature_dependency.py` / `scripts/add_domain_dependency.py` to wire the new module into `Modules.swift` and `RootFeature`'s dependency list, then regenerate. Don't manually create module directories — use these scaffolds so the wiring stays consistent.

Build/test runs through Xcode (`AMatDang.xcworkspace`) or `xcodebuild` on a generated scheme. There is no custom test runner — target names follow `<Name>FeatureTest`, `<Name>DomainTest`.

## Architecture

### Layer topology (strict, enforced by Tuist dependency declarations)

```
AMatDang (app)  →  RootFeature  →  Features/*  →  Domain/*  →  Shared
                        ↓               ↓            ↑
                      Data (live impls, imports Domain)
                        ↓
              BaseNetwork, LocalDataBase
```

- **Domain** modules (`Projects/Domain/*Domain`) declare UseCases and `<X>RepositoryInterface` as `public struct X: Sendable` — a struct-of-closures, NOT a separate `protocol X`. Each Domain ships (a) the struct declaration, (b) `<X>+Dependency.swift` with `TestDependencyKey.testValue` + `DependencyValues` extension, and (c) `<X>UseCase+Live.swift` with the `.live` factory. `.live` lives in Domain because it only composes other `@Dependency(\...)` injections — Domain never imports Data.
- **Data** (`Projects/Data/Data`) extends each `<X>RepositoryInterface` with a `.live` static factory (e.g. `AuthRepository.swift`) that calls BaseNetwork / LocalDataBase / Apple login. Data holds the `.live` factory only — no `DependencyKey.liveValue`. It imports Domain + BaseNetwork + LocalDataBase.
- **RootFeature** (`Projects/RootFeature/Sources/DI/*+Dependencies.swift`) is the composition root. It's the ONLY place `@retroactive DependencyKey.liveValue` extensions live, one file per concern (`UseCase+Dependencies.swift`, `Repository+Dependencies.swift`, plus one per platform client: `KeychainClient`, `NetworkService`, `AppleLoginManager`, `AmplitudeClient`, `UserDefaultClient`, `NotificationClient`, `LocalDataBaseService`, `GlobalState`). Each extension body just wires `liveValue → .live`.
- **Features** are SwiftUI + `@Observable` view models (no TCA). Each feature exposes `<Name>ViewFactory.create()` that constructs the view model and view. Features depend on Domain (never Data).
- **CommonFeature / DesignSystem** under `Projects/CommonFeature` — shared UI.
- **Shared** — value types, errors, utilities, and platform-client protocols (Keychain, UserDefault, Network, Amplitude, etc.) visible to all layers. Each platform client ships an in-memory `Stub<Client>` double (`<Client>+Stub.swift`) wired to `testValue` (see Platform client stubs).
- **BaseNetwork** wraps network requests (Moya-style `Target` types, e.g. `AuthValidationTarget`, called via `networkService.requestDDD(target)`).

### Dependency injection conventions

UseCases and Repositories are `public struct X: Sendable` (value types, no separate protocol) whose fields are `@Sendable` async-throws closures. Collaborators are pulled inside each closure via `@Dependency(\.xxx)`.

`TestDependencyKey` is conformed **directly on the struct** (no separate `XKey` wrapper):

```swift
extension XUseCase: TestDependencyKey {
  public static let testValue = XUseCase()          // @DependencyClient default init
}

public extension DependencyValues {
  var xUseCase: XUseCase {
    get { self[XUseCase.self] }
    set { self[XUseCase.self] = newValue }
  }
}
```

Two `testValue` styles coexist — pick based on whether the struct uses typed throws:

- **`@DependencyClient` macro** (UserDomain, BeverageDomain — no typed throws) → `testValue = XUseCase()`. The macro synthesizes a default init whose unoverridden closures fail via `unimplemented` when called.
- **Manual struct** (AuthDomain — `throws(AuthError)` breaks the macro) → `testValue` is a full `.init(closure1: { () async throws(XError) -> Y in throw XError.unknown("unimplemented: ...") }, ...)`. Explicit closure types are required per property; one-liner factories don't work with typed throws.

Adding a new dependency:
- **UseCase**: declare struct in Domain → `<X>UseCase+Dependency.swift` (TestDependencyKey + DependencyValues) → `<X>UseCase+Live.swift` (`.live` factory) → `liveValue → .live` line in RootFeature's `UseCase+Dependencies.swift`.
- **Repository**: declare `<X>RepositoryInterface` in Domain → `<X>RepositoryInterface+Dependency.swift` → `.live` factory in `Data/Data/Sources/<X>/Repository/` → `liveValue → .live` line in RootFeature's `Repository+Dependencies.swift`.
- **Platform client (Shared)**: protocol + live impl + `<Client>Key: TestDependencyKey` + `DependencyValues` → `<Client>+Stub.swift` next to it → `testValue` returns `Stub<Client>()` (never `fatalError`) → dedicated `<Client>+Dependencies.swift` in RootFeature for `liveValue`.

### Platform client stubs (Shared)

Platform protocols ship an in-memory `Stub<Client>` alongside the live impl: `AMDKeychainClient+Stub.swift` → `StubKeychainClient`, `AMDUserDefaultClient+Stub.swift` → `StubUserDefaultClient`. `TestDependencyKey.testValue` returns the stub so tests and SwiftUI previews never touch real Keychain/UserDefaults. Do NOT leave `fatalError` as the test default for platform clients.

Stub shape:
- `public final class Stub<Client>: <Client>Protocol, Sendable` (no `@unchecked`)
- `Mutex<State>` from `import Synchronization` (iOS 18+) for internal storage
- Failure injection via `init` parameters (e.g. `StubKeychainClient(setError: AMDKeychainError.invalidData)`) — the class stays immutable for natural `Sendable` conformance

### Testing conventions

- **Swift Testing** (`import Testing`, `@Suite`, `@Test`, `#expect`, `#require`) — not XCTest. Built into Xcode 16+ / iOS 18 SDK, no extra dependency.
- Test targets follow `<Name>DomainTest` / `<Name>FeatureTest` naming (`.unitTests` product, created by `makeDomain` / `makeFeature`). Sources live under `Tests/Sources/**`.
- **Test `UseCase.live`, not `.testValue`.** `.live` is the real orchestration logic; `.testValue` is just the unimplemented scaffold. Inject collaborators via `withDependencies`:

  ```swift
  try await withDependencies {
    $0.authRepository = repo
    $0.keychainClient = StubKeychainClient()
  } operation: {
    try await AuthUseCase.live.loginWithApple()
  }
  ```

  `@Dependency` inside `.live`'s closures resolves at call-time via TaskLocal, so overrides applied by `withDependencies` propagate correctly.
- **Overriding closures on struct-of-closure dependencies**:
  - `@DependencyClient` macro type → `var repo = Interface(); repo.closure = { ... }`
  - manual struct with typed throws → `var repo = Interface.testValue; repo.closure = { () async throws(XError) -> Y in ... }` (explicit closure types required)
- **Platform client tests** — use stubs directly (`StubKeychainClient()`, `StubUserDefaultClient()`); they're already the `testValue` default. Failure scenarios: pass the knob through init (`StubKeychainClient(setError: ...)`).
- **Call capture / side-effect probing** inside test closures — use `Mutex<T>` from `import Synchronization`. No `@unchecked Sendable` classes.
- **Repetition** — collapse input variations into `@Test(arguments: [...])` parameterized tests instead of duplicating methods.

### Module product types

Domain modules, Data, CommonFeature, DesignSystem, RootFeature, and BaseNetwork/LocalDataBase are **`.staticFramework`**. Feature modules switch between `.staticFramework` (release-style) and `.framework` (dev) based on the `TUIST_IS_DEV` env var (set by `ISDEV=true make generate`). Use dev mode for faster incremental builds; ship builds with static linkage.

### SwiftUI / view model pattern

View models conform to a `ViewModelable` protocol (CommonFeature) with associated `State: Equatable` and `Action` types, plus `handleAction(_:)`. They are `@Observable @MainActor public final class`. Views receive the VM via constructor (`let viewModel: HomeViewModel`), not `@StateObject`/`@State`. Factories (`<Name>ViewFactory`) are the entry point used by RootFeature's navigation.

## Conventions worth knowing

- 2-space indentation everywhere (enforced in Project options).
- Typed throws (`throws(AuthError)`) are used pervasively in Domain/Data layers — match the existing style when adding new async APIs.
- Korean domain language appears in code (`BeverageCalendar`, `SugarIntakeRecord`, etc.) and comments — preserve existing Korean identifiers when editing.
- Entitlements file is shared at `XCConfig/AMatDang.entitlements`; DEV/PROD configs at `XCConfig/DEV.xcconfig`, `XCConfig/PROD.xcconfig`.
