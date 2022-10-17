# EssentialGhibli

This is a demo app digesting the [iOS Lead Essentials](https://iosacademy.essentialdeveloper.com/p/ios-lead-essentials/) program at the [Essential Developer Academy](https://www.essentialdeveloper.com).

The app presents the feed of [Studio Ghibli](https://en.wikipedia.org/wiki/Studio_Ghibli) films. The app caches the feed so that the user could enjoy the feed regardless of the connectivity, and images, to prevent excessive bandwidth usage.

![The app](./Docs/app.png)

Under the hood, it is a project with hyper-modular architecture with decoupled components, with modularity enforced by placing modules into separate targets in the `EssentialGhibli` Swift Package.

## Instructions

Open the `App/EssentialGhibli.xcodeproj` with Xcode 14.x and select the `EssentialGhibli` scheme to run the app on the simulator.

## Modules

The `hyper-modular` architecture allows to develop, maintain, extend, replace, reuse, and test the components in isolation. It simplifies composition, deployment, and team-wide communication via a light-weight Preview App (isolated module-specific apps). It follows `SOLID principles` and `Dependency Injection` patterns.

![File Structure](./Docs/structure.png)

with decoupled components

![Components](./Docs/components.png)

### Build time

Modules dependency done right significantly reduces build time. This project is definitely not huge, but it's clear that this approach allows utilizing Xcode parallel build system:

![Xcode project clean build timeline](./Docs/build_timeline.png)

![CPU](./Docs/cpu.png)

### Composition

The `Root Composition` is implemented in the `EssentialGhibliApp`: `UIComposer` is responsible for the UI, and `LoaderComposer` glues together `API` and `Cache` and manages async behavior (Cache is sync) using Combine.

### Presentation

`Presentation` is a platform-agnostic module that defines abstract `ResourceState`: loading, loaded, and loading error, for generic `Resource` and `StateError`.

### UI

There are three concrete modules: `DetailFeature`, `ListFeature`, `RowFeature`, and one generic `GenericResourceView`, that renders three states of any abstract resource: loading, loaded, and loading error.

UI Components are implemented with `SwiftUI`. Previews are designed to show the rendering of different states - loading, loaded, load error - and are covered with snapshot tests - see [Tests](#tests).

### API

`API` has three modules: reusable app-agnostic interface `SharedAPI` and its `URLSession` implementation in `SharedAPIInfra`, and `API` itself - the app-specific endpoint and mapper.

Tests cover `API` and `SharedAPIInfra` with `URLProtocolStub: URLProtocol`.

### Cache

`Cache` module implements generic `FeedCache` and defines `FeedStore` - the interface for the infrastructure, which is implemented with CoreData in `CacheInfra`.

Tests cover both modules, separating by uses cases, and extensively using DSL to facilitate testing and decouple tests from implementation details.

### Localization

English and Russian localizations are tested, in the app module and in UI modules.

## Tests

Extensive use of `TDD` and test `DSL` to decouple tests from the implementation details.

UI Components are tested using snapshots with [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing). This testing covers light/dark modes and localization.

![localization and color scheme](./Docs/localization_and_color_scheme.png)

## CI

For the demo, a simple `CI` with `GitHub actions` workflow is used: build and run all tests with scheme `CI_iOS` run on push to the `main` branch. Another workflow with the same functionality could be triggered manually. Both `YAML` scripts call `clean_build_test.sh` shell script.

## References

* [Studio Ghibli API](https://ghibliapi.herokuapp.com/#)

* [Studio Ghibli - Wikipedia](https://en.wikipedia.org/wiki/Studio_Ghibli)
