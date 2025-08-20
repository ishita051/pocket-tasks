# 📱 PocketTasks

A beautiful, feature-rich Flutter task management app with local storage, real-time search, filtering, and elegant light/dark theme support.


## ✨ Features

### 🎯 Core Functionality
- ✅ **Add Tasks** - Create new tasks with validation
- 🔄 **Toggle Completion** - Mark tasks as done/active with one tap
- 🗑️ **Delete Tasks** - Swipe to delete with undo functionality
- 🔍 **Real-time Search** - Debounced search (300ms) for smooth performance
- 📊 **Smart Filtering** - Filter by All, Active, or Done tasks
- 💾 **Local Persistence** - Tasks saved locally with SharedPreferences

### 🎨 Design & UX
- 🌙 **Light/Dark Theme Toggle** - Manual theme switching with system detection
- 🎨 **Modern Material 3 Design** - Beautiful gradients and shadows
- 📈 **Progress Indicator** - Visual completion tracking
- ↩️ **Undo Actions** - Undo task toggles and deletions
- 🏃‍♀️ **Smooth Animations** - 200-300ms transitions throughout
- 📱 **Responsive Design** - Works great on all screen sizes

### ⚡ Performance
- 🚀 **ListView.builder** - Efficient scrolling for 100+ tasks
- ⏱️ **Debounced Search** - Prevents excessive filtering
- 🎯 **Optimized State Management** - Minimal rebuilds with ChangeNotifier
- 💨 **Fast Storage** - JSON serialization for quick persistence

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** `>=3.0.0`
- **Dart SDK** `>=3.0.0`
- **Android Studio** or **VS Code** with Flutter extensions

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/ishita051/pocket-tasks.git
cd pocket-tasks
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Running Tests
```bash
flutter test
```

## 🏗️ Architecture

### 📁 Project Structure
```
lib/
├── main.dart                 # App entry point & theme management
├── models/
│   └── task.dart            # Task data model with JSON serialization
├── services/
│   ├── task_service.dart    # State management & business logic
│   └── task_storage.dart    # Local storage operations
├── screens/
│   └── home_screen.dart     # Main UI screen
└── widgets/
    └── task_tile.dart       # Individual task list item
```

### 🧠 State Management
- **Pattern**: `ChangeNotifier` with custom Provider implementation
- **Reactive Updates**: Automatic UI updates when data changes
- **Debounced Search**: 300ms delay for optimal performance
- **Local Storage**: Automatic persistence on all operations

### 💾 Data Flow
1. **User Action** → UI Widget
2. **Widget** → TaskService (State Management)
3. **TaskService** → TaskStorage (Persistence)
4. **State Change** → UI Update (Reactive)

## 🎨 Design System

### Color Palette

#### Light Theme
- **Primary**: `#6B46C1` (Deep Purple)
- **Secondary**: `#10B981` (Emerald)
- **Tertiary**: `#F59E0B` (Amber)
- **Background**: `#F1F5F9` (Light Slate)
- **Surface**: `#F8FAFC` (Very Light)

#### Dark Theme
- **Primary**: `#8B5CF6` (Light Purple)
- **Secondary**: `#34D399` (Light Emerald)
- **Tertiary**: `#FBBF24` (Light Amber)
- **Background**: `#0F172A` (Dark Slate)
- **Surface**: `#1E293B` (Medium Dark)

### Typography
- **Headers**: Bold, primary color
- **Body**: Medium weight, adaptive to theme
- **Hints**: 60% opacity for subtle guidance

## 📚 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter: ^3.0.0
  shared_preferences: ^2.2.2  # Local storage
  uuid: ^4.2.1               # Unique task IDs
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test: ^1.0.0
  flutter_lints: ^3.0.0     # Code quality
```

## 🧪 Testing

The app includes comprehensive unit tests covering:

- ✅ **Search Functionality** - Text-based task filtering
- ✅ **Filter Logic** - All/Active/Done task states  
- ✅ **Combined Operations** - Search + filter combinations
- ✅ **Edge Cases** - Empty results, case sensitivity

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🚧 Roadmap

### Version 2.0 Planned Features
- 📅 **Due Dates** - Set task deadlines
- 🏷️ **Categories** - Organize tasks by type
- 📊 **Analytics** - Task completion insights
- ☁️ **Cloud Sync** - Multi-device synchronization
- 🔔 **Notifications** - Task reminders
- 📱 **Widgets** - Home screen quick access

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
