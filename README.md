# Product Dashboard - Flutter Web Application

A modern, responsive Product Dashboard built with Flutter Web and BLoC/Cubit for state management. This application demonstrates best practices in Flutter architecture, state management, and UI/UX design.

## Features

### Core Features
- **Product List Page**: Display products in a responsive DataTable with complete CRUD operations
- **Search & Filter**: Real-time search and category-based filtering
- **Add/Edit Product Modal**: Form validation and reactive state updates via BLoC
- **Product Details Page**: Dedicated page showing complete product information
- **Responsive Design**: Adapts seamlessly to different screen sizes
- **Sidebar Navigation**: Clean navigation with Dashboard, Products, and Settings

### Technical Highlights
- **State Management**: Flutter BLoC pattern for predictable state management
- **Clean Architecture**: Feature-based folder structure following clean architecture principles
- **API Integration**: Connected to DummyJSON API for realistic data
- **Routing**: go_router for declarative navigation
- **Dependency Injection**: GetIt for clean dependency management
- **Material 3**: Modern UI with Material Design 3

## Architecture

The project follows **Clean Architecture** with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── di/                 # Dependency injection setup
│   ├── errors/             # Error handling
│   ├── routing/            # Navigation configuration
│   ├── theme/              # App theming
│   └── widgets/            # Shared widgets
├── features/
│   └── product/
│       ├── data/
│       │   ├── datasources/    # API data sources
│       │   ├── models/         # Data models
│       │   └── repositories/   # Repository implementations
│       ├── domain/
│       │   ├── entities/       # Business entities
│       │   └── repositories/   # Repository contracts
│       └── presentation/
│           ├── bloc/           # BLoC state management
│           ├── pages/          # UI pages
│           └── widgets/        # Feature widgets
└── main.dart
```

## Tech Stack

- **Framework**: Flutter 3.10.4+
- **State Management**: flutter_bloc 8.1.6
- **Routing**: go_router 14.6.2
- **Dependency Injection**: get_it 8.0.2
- **HTTP Client**: http 1.2.2
- **Functional Programming**: dartz 0.10.1
- **Value Equality**: equatable 2.0.5

## Getting Started

### Prerequisites
- Flutter SDK (3.10.4 or higher)
- Dart SDK
- Web browser (Chrome recommended)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd interview_test
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run -d chrome
```

Or for production build:
```bash
flutter build web
```

## Usage

### Authentication
1. **Login**: Use one of the demo credentials:
   - **Admin**: `admin@test.com` / `admin123`
   - **User**: `user@test.com` / `user123`
   - **Demo**: `demo@test.com` / `demo123`
2. **Logout**: Click on your profile avatar in the top-right and select "Logout"

### Product Management
1. **View Products**: Main page displays paginated products in a data table
2. **Search**: Use the search bar to filter products by name, description, or category
3. **Filter by Category**: Select a category from the dropdown to filter products
4. **Sort Columns**: Click on column headers (ID, Name, Category, Price, Stock) to sort
5. **Pagination**: Use the pagination controls at the bottom to navigate pages
6. **Add Product**: Click "Add Product" button and fill in the form
7. **Edit Product**: Click the edit icon in the actions column
8. **Delete Product**: Click the delete icon and confirm deletion
9. **View Details**: Click on a product name or the view icon to see full details

### Theme
- **Toggle Theme**: Click the theme icon in the top-right to switch between light and dark modes

### Navigation
- **Dashboard/Products**: Main product list view
- **Settings**: Application settings
- **Sidebar Toggle**: Click the menu icon to show/hide the sidebar

## Features Implemented

### Required Features
- [x] Product list with DataTable
- [x] Product properties (ID, Name, Category, Price, Stock Status)
- [x] Search and filter functionality
- [x] Add/Edit product modal with validation
- [x] Reactive state management with BLoC
- [x] Product details page
- [x] Navigation between pages
- [x] Mock API integration (DummyJSON)
- [x] Clean architecture folder structure
- [x] Responsive design
- [x] go_router for navigation

### Bonus Features (All Implemented!)
- [x] **Pagination**: Navigate through products with adjustable rows per page (5, 10, 25, 50)
- [x] **Column Sorting**: Sort products by ID, Name, Category, Price, or Stock
- [x] **Dark/Light Theme Switcher**: Toggle between themes with persistent preference
- [x] **Mock Authentication**: Login page with session management and protected routes
- [x] **Deployment Ready**: Firebase Hosting and Vercel configuration files included
- [x] Modern Material 3 design
- [x] Sidebar navigation
- [x] AppBar with user profile

## Project Structure Details

### BLoC Pattern
The app uses BLoC (Business Logic Component) pattern for state management:
- **Events**: User actions (LoadProducts, SearchProducts, AddProduct, etc.)
- **States**: UI states (ProductLoading, ProductLoaded, ProductError, etc.)
- **Bloc**: Business logic handling events and emitting states

### Repository Pattern
- **Abstract Repository**: Defines contracts in domain layer
- **Repository Implementation**: Implements contracts in data layer
- **Data Sources**: Handles API communication

### Dependency Injection
GetIt service locator manages dependencies:
- Lazy singletons for repositories and data sources
- Factory pattern for BLoCs

## API Integration

The app integrates with [DummyJSON API](https://dummyjson.com/):
- **GET** `/products`: Fetch all products
- **GET** `/products/:id`: Fetch single product
- **POST** `/products/add`: Add product
- **PUT** `/products/:id`: Update product
- **DELETE** `/products/:id`: Delete product
- **GET** `/products/search?q=query`: Search products

## Responsive Design

The application adapts to different screen sizes:
- **Wide screens (>800px)**: Full sidebar + content area
- **Narrow screens (<800px)**: Collapsible sidebar
- **Data tables**: Horizontal scrolling on small screens
- **Product details**: Stacked layout on mobile

## Deployment

This project is ready to deploy! See [DEPLOYMENT.md](DEPLOYMENT.md) for comprehensive deployment instructions.

### Quick Deploy

**Vercel:**
```bash
flutter build web --release
vercel --prod
```

**Firebase Hosting:**
```bash
flutter build web --release
firebase deploy --only hosting
```

Configuration files included:
- `firebase.json` - Firebase Hosting configuration
- `.firebaserc` - Firebase project configuration
- `vercel.json` - Vercel deployment configuration

## Future Enhancements

- ~~Pagination for large datasets~~ ✅ Implemented
- ~~Column sorting in data table~~ ✅ Implemented
- ~~Dark/Light theme switcher~~ ✅ Implemented
- ~~User authentication~~ ✅ Implemented (Mock)
- Real backend integration
- Local storage/caching
- Export functionality (CSV/PDF)
- Advanced filters
- Product images upload
- Analytics dashboard

## Development

### Adding New Features
1. Create feature folder in `lib/features/`
2. Implement domain, data, and presentation layers
3. Register dependencies in `injection_container.dart`
4. Add routes in `app_router.dart`

### Testing
```bash
flutter test
```

## License

This project is created for interview purposes.

## Contact

For questions or feedback, please reach out to the repository owner.
