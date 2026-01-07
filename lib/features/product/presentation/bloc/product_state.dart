import 'package:equatable/equatable.dart';
import 'package:interview_test/features/product/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;
  final String selectedCategory;
  final int currentPage;
  final int itemsPerPage;
  final String sortColumn;
  final bool sortAscending;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.currentPage = 0,
    this.itemsPerPage = 10,
    this.sortColumn = '',
    this.sortAscending = true,
  });

  @override
  List<Object?> get props => [
        products,
        filteredProducts,
        searchQuery,
        selectedCategory,
        currentPage,
        itemsPerPage,
        sortColumn,
        sortAscending,
      ];

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
    String? selectedCategory,
    int? currentPage,
    int? itemsPerPage,
    String? sortColumn,
    bool? sortAscending,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  List<Product> get paginatedProducts {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, filteredProducts.length);
    if (startIndex >= filteredProducts.length) return [];
    return filteredProducts.sublist(startIndex, endIndex);
  }

  int get totalPages => (filteredProducts.length / itemsPerPage).ceil();
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
