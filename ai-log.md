

好的，我來解釋 SwiftUI 中常見的屬性包裝器（Property Wrappers）：

### 1. @State
```swift
struct ContentView: View {
    @State private var count = 0
    
    var body: some View {
        Button("點擊次數: \(count)") {
            count += 1
        }
    }
}
```
- 用於儲存 View 的本地狀態
- 當值改變時會觸發 View 重新渲染
- 通常標記為 `private`
- 適合簡單的資料類型（Int、String、Bool 等）

### 2. @Binding
```swift
struct ChildView: View {
    @Binding var text: String
    
    var body: some View {
        TextField("輸入文字", text: $text)
    }
}

struct ParentView: View {
    @State private var text = ""
    
    var body: some View {
        ChildView(text: $text)
    }
}
```
- 創建對其他 View 狀態的引用
- 允許子 View 修改父 View 的狀態
- 使用 `$` 符號傳遞綁定

### 3. @StateObject
```swift
class UserViewModel: ObservableObject {
    @Published var username = ""
}

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        TextField("用戶名", text: $viewModel.username)
    }
}
```
- 用於創建和管理引用類型（class）的實例
- 對象必須遵循 `ObservableObject` 協議
- View 的生命週期內只創建一次
- 適合 ViewModel 的創建

### 4. @ObservedObject
```swift
struct ProfileView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        Text(viewModel.username)
    }
}
```
- 用於從外部接收 ObservableObject
- 不負責創建實例，只負責觀察
- 當被觀察的對象發生變化時更新 UI

### 5. @EnvironmentObject
```swift
class AppSettings: ObservableObject {
    @Published var isDarkMode = false
}

// 在 App 層級注入
@main
struct MyApp: App {
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}

// 在任何子視圖中使用
struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        Toggle("深色模式", isOn: $settings.isDarkMode)
    }
}
```
- 用於在整個 App 中共享數據
- 不需要通過 View 層層傳遞
- 必須由父視圖提供數據

### 6. @Published
```swift
class UserViewModel: ObservableObject {
    @Published var name = ""
    @Published var age = 0
}
```
- 用在 ObservableObject 中標記需要觀察的屬性
- 當屬性值改變時，會通知所有觀察者

### 7. @AppStorage
```swift
struct SettingsView: View {
    @AppStorage("username") private var username = ""
    
    var body: some View {
        TextField("用戶名", text: $username)
    }
}
```
- UserDefaults 的包裝器
- 自動在本地儲存和讀取數據
- 當值改變時自動更新 UI

### 8. @SceneStorage
```swift
struct DocumentView: View {
    @SceneStorage("selectedTab") private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 標籤內容
        }
    }
}
```
- 用於儲存 Scene 相關的狀態
- 在 App 重啟後恢復
- 適合儲存 UI 狀態（如選中的標籤）

使用建議：
1. 使用 `@State` 處理簡單的本地狀態
2. 使用 `@StateObject` 創建 ViewModel
3. 使用 `@ObservedObject` 接收外部的 ViewModel
4. 使用 `@EnvironmentObject` 共享全局狀態
5. 使用 `@AppStorage` 持久化簡單數據
6. 使用 `@Binding` 在視圖間傳遞可修改的值


# user defaule

我可以幫你示範如何使用 UserDefaults 來儲存轉盤資訊在本地。首先，我們需要建立一個可編碼的結構來儲存轉盤資料：

```swift:SpinWheelData.swift
struct SpinWheelItem: Codable {
    var title: String
    var color: String // 儲存顏色的 hex 值
}

struct SpinWheelData: Codable {
    var items: [SpinWheelItem]
    var name: String
    var createdDate: Date
}
```

然後建立一個管理儲存的類別：

```swift:SpinWheelManager.swift
class SpinWheelManager {
    static let shared = SpinWheelManager() // 單例模式
    private let userDefaults = UserDefaults.standard
    private let spinWheelsKey = "savedSpinWheels"
    
    // 儲存轉盤
    func saveWheel(_ wheel: SpinWheelData) {
        var savedWheels = getAllWheels()
        savedWheels.append(wheel)
        
        if let encoded = try? JSONEncoder().encode(savedWheels) {
            userDefaults.set(encoded, forKey: spinWheelsKey)
        }
    }
    
    // 取得所有轉盤
    func getAllWheels() -> [SpinWheelData] {
        guard let data = userDefaults.data(forKey: spinWheelsKey),
              let savedWheels = try? JSONDecoder().decode([SpinWheelData].self, from: data) else {
            return []
        }
        return savedWheels
    }
    
    // 刪除轉盤
    func deleteWheel(at index: Int) {
        var savedWheels = getAllWheels()
        guard index < savedWheels.count else { return }
        
        savedWheels.remove(at: index)
        if let encoded = try? JSONEncoder().encode(savedWheels) {
            userDefaults.set(encoded, forKey: spinWheelsKey)
        }
    }
}
```

使用範例：

```swift
// 建立新轉盤
let newWheel = SpinWheelData(
    items: [
        SpinWheelItem(title: "選項1", color: "FBE488"),
        SpinWheelItem(title: "選項2", color: "75AB53")
    ],
    name: "我的轉盤",
    createdDate: Date()
)

// 儲存轉盤
SpinWheelManager.shared.saveWheel(newWheel)

// 讀取所有轉盤
let savedWheels = SpinWheelManager.shared.getAllWheels()

// 刪除轉盤
SpinWheelManager.shared.deleteWheel(at: 0)
```

這個實作的特點：

1. 使用 `UserDefaults` 儲存資料，適合較小量的資料
2. 資料會以 JSON 格式編碼後儲存
3. 支援多個轉盤的儲存和管理
4. 使用單例模式方便在不同畫面中存取

如果你的轉盤資料較大或需要更複雜的查詢功能，建議改用 CoreData 或 SQLite。

要在 SwiftUI 中使用這個功能，你可以配合 `@State` 或 `@StateObject` 來更新 UI：

```swift:SpinWheelView.swift
struct SpinWheelView: View {
    @State private var wheels: [SpinWheelData] = []
    
    var body: some View {
        List(wheels, id: \.name) { wheel in
            Text(wheel.name)
        }
        .onAppear {
            // 載入已儲存的轉盤
            wheels = SpinWheelManager.shared.getAllWheels()
        }
    }
}
```

這樣就能實現轉盤資料的本地儲存和讀取功能了。
