# 更新日誌

🌐 **Language / 語言**：[English](CHANGELOG.md) | **繁體中文**

## 0.5.1
#### 2026-08-21
- **角色控制器跳躍**：在 `CharacterControllerScene` 示範中新增 **跳躍** 按鈕，支援基於脈衝的垂直跳躍，並配有螢幕 UI 控制項。
- **搖桿輸入改進**：優化 `CharacterControllerScene` 中的搖桿互動，提供可設定的輸入區域並改善觸控響應性。
- **Windows DLL 更新**：重新建置並更新 `prebuilt/rapier_ffi.dll`。
- **CompoundScene 桌子新增**：新增 `addTable` — 一個由平坦桌面和四個方形桌腳組成的複合剛體，搭配個別的 `ColliderDesc.cuboid` 偏移量以及更深的木頭色子網格著色。

## 0.5.0
#### 2026-08-19
- **運動學角色控制器**：引入 `KinematicCharacterController`，支援 3D 角色物理導航，涵蓋自動台階攀爬、坡面滑動、地面吸附，以及對動態物體施加衝力（`applyImpulsesToDynamicBodies`）。
- **場景查詢**：新增完整的 `SceneQuery` API，包含射線投射（`castRay`、`castRayAndGetNormal`、`intersectionWithRay`、`intersectionsWithRay`）與形狀投射（`castShape`、`intersectionsWithShape`），並支援可自訂的查詢過濾旗標（`QueryFilterFlags`）。
- **明確膠囊軸對齊**：重構 `ColliderShapeType` 與 `ColliderDesc`，在 Dart API 和 Rust FFI 中明確支援軸對齊膠囊體變體（`capsuleX`、`capsuleY`、`capsuleZ`）。
- **FFI 模組化**：將原生 Rust FFI 程式碼模組化為結構化檔案（`world`、`rigid_body`、`collider`、`joint`、`character_controller`、`scene_query`），並將 Dart FFI 綁定拆分為獨立的實作模組（`lib/src/bindings/ffi/`）。
- **新互動示範**：在範例專案（`example/lib/main_3d.dart`）中新增 3D 角色控制器示範及場景查詢射線投射／形狀投射示範。
- **引擎升級**：將底層原生引擎依賴升級至 `rapier3d v0.34.0`。

## 0.4.1
#### 2026-07-19
- **CompoundScene 啞鈴生成器**：在 `CompoundScene` 中新增基於時間的啞鈴生成功能，從 `(0, 0, 20)` 位置以每秒 10 個的速度持續生成複合剛體，並設有可設定的數量上限。
- **BaseScene 相機與地面**：將預設相機距離增加至 30，並將地面半尺寸擴展為 10，搭配更大的棋盤格紋理。

## 0.4.0
#### 2026-06-27
- **Windows 平台支援**：新增 Windows 平台支援，包含 C++ 插件實作、CMake 設定，以及預建原生 `rapier_ffi.dll` 函式庫的打包。
- **Swift Package Manager (SPM) 支援**：重組 iOS 與 macOS 原生目錄（`ios/rapier_physics` 和 `macos/rapier_physics`），並新增 `Package.swift` 以支援透過 Swift Package Manager 整合。
- **建置腳本自動化**：重構 `native/rapier_ffi/build.sh`，使其直接將 `.xcframework` 輸出至 iOS 和 macOS 的 `rapier_physics` 子資料夾，以符合 SPM 結構。

## 0.3.1
#### 2026-05-07
- **時間步長 API**：為 `RapierWorld` 新增 `timestep` getter 和 setter，允許使用者控制模擬的積分步長（`dt`）。
- **FFI 命名重構**：將所有 FFI 函式名稱標準化為 `rapier_[元件]_[動作]` 命名慣例（例如 `rapier_rigid_body_create`、`rapier_collider_get_position_x`），提升跨原生與 Web 平台的一致性。
- **API 精煉**：更新 `ColliderDesc` 中 `cylinder`、`cone` 和 `capsule` 的建構子，採用更直觀的參數順序：`(radius, halfHeight)` 取代原先的 `(halfHeight, radius)`。
- **平台同步**：更新 iOS／macOS Swift 插件及 Web／WASM 橋接層，以支援新的時間步長 FFI 符號並改善符號可見性。

## 0.3.0
#### 2026-05-03
- **統一碰撞體 API**：引入 `ColliderDesc` 架構，提供更健全且可擴充的碰撞體建立方式。
- **原生本地變換支援**：
    - 在原生 FFI 層直接新增 `localPosition` 與 `localRotation` 支援。
    - 碰撞體現在可在建立時相對於其父剛體進行定位與旋轉，提升物理穩定性。
- **API 清理**：
    - 移除冗餘的專用碰撞體建立方法（`createBoxCollider`、`createSphereCollider` 等），改用統一的 `createCollider` API。
    - 更新 `addBox`、`addSphere` 及其他便利方法，使用統一的 `RigidBodyDesc` 系統以提升可擴充性。
- **FFI 記憶體優化**：跨 Rust、Dart 和 Swift 標準化 `ColliderDesc` 記憶體佈局（64 位元組），實現高效的零拷貝跨邊界通訊。
- **平台同步**：更新 iOS／macOS Swift 插件及 Web／WASM 互操作，以支援擴展的原生碰撞體變換資料。

## 0.2.0
#### 2026-04-23
- **力與衝力 API**：為 `RigidBody` 新增 `addForce`、`addTorque`、`applyImpulse`、`applyTorqueImpulse` 及其 `AtPoint` 變體。
- **速度控制**：新增 `setLinearVelocity` 和 `setAngularVelocity`，用於精細控制剛體運動。
- **實體移除 API**：
    - 為 `RapierWorld` 新增 `removeRigidBody`、`removeCollider` 和 `removeJoint`。
    - 實作內部追蹤的自動清理（例如移除剛體時，也會同步清除 Dart 狀態中關聯的碰撞體和關節）。
- **關係追蹤**：
    - 為 `RigidBody` 新增 `colliders` 和 `joints` getter，支援實體間的雙向導覽。
    - 改善內部 `_bodyColliders` 與 `_bodyJoints` 映射，實現更健全的狀態管理。
- **CCD 支援**：為 `RigidBody` 新增 `setCCD(bool enabled)`，防止高速物體穿透。
- **高度場碰撞體**：新增使用高度圖的地形碰撞支援（`addHeightfield`）。
- **Apple 平台優化**：
    - 透過 Swift 插件橋接改善 iOS／macOS 的符號導出與連結。
    - 為所有 FFI 符號新增明確的 `@_silgen_name` 宣告，確保 Release 版本的穩定性。
- **關節支援**：新增完整的關節系統，包含：
    - `FixedJoint`、`SphericalJoint`、`RevoluteJoint`、`PrismaticJoint`、`GenericJoint` 和 `RopeJoint`。
    - 支援直接將剛體附加至世界的輔助方法（`*ToWorld`）。
- **馬達與約束**：
    - 新增旋轉關節和平移關節的馬達支援。
    - 透過 `GenericJoint` 新增 `lockJointAxis` 和 `setJointLimits`，用於精細的約束控制。
- **新碰撞體**：新增 `Cone`（圓錐體）碰撞體支援。
- **世界生命週期**：
    - 為 `RapierWorld` 新增 `destroy()`，用於正確釋放資源。
    - 支援原生 `groundBody`，更方便地將關節錨定至靜態世界。
- **引擎升級**：將底層原生引擎依賴升級至 `rapier3d v0.32.0`。
- **範例應用程式增強**：新增牛頓擺示範、偵錯切換（輔助工具、線框模式）、陰影控制，以及物理重置功能。

## 0.1.0
#### 2026-04-09
- **跨平台重構**：重大架構更新，透過抽象綁定和條件式匯入，無縫支援原生與 Web 平台。
- **Web 支援**：透過 `dart:js_interop` 實現完整的 WebAssembly（WASM）支援。
- **Android 修復**：採用標準 `jniLibs` 目錄結構並依名稱載入，解決原生函式庫載入問題。
- **API 改進**：
    - 新增非同步 `init()`，實現健全的跨平台初始化。
    - 新增元件式狀態 getter，提升 WASM 相容性。
    - 支援多種 `RigidBodyType`（Fixed、Dynamic、Kinematic）。
- **自動化工具**：更新 `build.sh`，自動分發 Android、iOS、macOS 和 Web 二進位檔案。

## 0.0.1
#### 2026-04-03
- 初始版本發布，提供基礎的 Rapier 物理引擎 FFI 橋接。
