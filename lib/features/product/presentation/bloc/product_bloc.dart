import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/features/product/domain/entities/product.dart';
import 'package:interview_test/features/product/domain/repositories/product_repository.dart';
import 'package:interview_test/features/product/presentation/bloc/product_event.dart';
import 'package:interview_test/features/product/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProductsByCategory>(_onFilterByCategory);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<GetProductById>(_onGetProductById);
    on<ChangePage>(_onChangePage);
    on<ChangeItemsPerPage>(_onChangeItemsPerPage);
    on<SortProducts>(_onSortProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await repository.getAllProducts();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        filteredProducts: products,
      )),
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(currentState.copyWith(
          filteredProducts: _filterByCategory(
            currentState.products,
            currentState.selectedCategory,
          ),
          searchQuery: '',
        ));
      } else {
        final filtered = currentState.products.where((product) {
          return product.title.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query);
        }).toList();

        final categoryFiltered = _filterByCategory(
          filtered,
          currentState.selectedCategory,
        );

        emit(currentState.copyWith(
          filteredProducts: categoryFiltered,
          searchQuery: event.query,
        ));
      }
    }
  }

  Future<void> _onFilterByCategory(
    FilterProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      List<Product> filtered = _filterByCategory(
        currentState.products,
        event.category,
      );

      if (currentState.searchQuery.isNotEmpty) {
        final query = currentState.searchQuery.toLowerCase();
        filtered = filtered.where((product) {
          return product.title.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query);
        }).toList();
      }

      emit(currentState.copyWith(
        filteredProducts: filtered,
        selectedCategory: event.category,
      ));
    }
  }

  List<Product> _filterByCategory(List<Product> products, String category) {
    if (category == 'All') {
      return products;
    }
    return products.where((p) => p.category == category).toList();
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoading());

      final result = await repository.addProduct(event.product);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (product) {
          final updatedProducts = [...currentState.products, product];
          emit(ProductLoaded(
            products: updatedProducts,
            filteredProducts: updatedProducts,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
          ));
          emit(const ProductOperationSuccess('Product added successfully'));
          emit(ProductLoaded(
            products: updatedProducts,
            filteredProducts: updatedProducts,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
          ));
        },
      );
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoading());

      final result = await repository.updateProduct(event.product);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (updatedProduct) {
          final updatedProducts = currentState.products.map((p) {
            return p.id == updatedProduct.id ? updatedProduct : p;
          }).toList();

          emit(ProductLoaded(
            products: updatedProducts,
            filteredProducts: updatedProducts,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
          ));
          emit(const ProductOperationSuccess('Product updated successfully'));
          emit(ProductLoaded(
            products: updatedProducts,
            filteredProducts: updatedProducts,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
          ));
        },
      );
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoading());

      final result = await repository.deleteProduct(event.productId);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (_) {
          final updatedProducts = currentState.products
              .where((p) => p.id != event.productId)
              .toList();

          emit(ProductLoaded(
            products: updatedProducts,
            filteredProducts: updatedProducts,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
          ));
          emit(const ProductOperationSuccess('Product deleted successfully'));
          emit(ProductLoaded(
            products: updatedProducts,
            filteredProducts: updatedProducts,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
          ));
        },
      );
    }
  }

  Future<void> _onGetProductById(
    GetProductById event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await repository.getProductById(event.productId);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) {
        if (state is ProductLoaded) {
          final currentState = state as ProductLoaded;
          emit(currentState);
        } else {
          emit(ProductLoaded(
            products: [product],
            filteredProducts: [product],
          ));
        }
      },
    );
  }

  void _onChangePage(
    ChangePage event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(currentState.copyWith(currentPage: event.page));
    }
  }

  void _onChangeItemsPerPage(
    ChangeItemsPerPage event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(currentState.copyWith(
        itemsPerPage: event.itemsPerPage,
        currentPage: 0,
      ));
    }
  }

  void _onSortProducts(
    SortProducts event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final column = event.column;
      final ascending = currentState.sortColumn == column
          ? !currentState.sortAscending
          : true;

      final sortedProducts = List<Product>.from(currentState.filteredProducts);

      sortedProducts.sort((a, b) {
        int comparison;
        switch (column) {
          case 'id':
            comparison = a.id.compareTo(b.id);
            break;
          case 'title':
            comparison = a.title.compareTo(b.title);
            break;
          case 'category':
            comparison = a.category.compareTo(b.category);
            break;
          case 'price':
            comparison = a.price.compareTo(b.price);
            break;
          case 'stock':
            comparison = a.stock.compareTo(b.stock);
            break;
          default:
            comparison = 0;
        }
        return ascending ? comparison : -comparison;
      });

      emit(currentState.copyWith(
        filteredProducts: sortedProducts,
        sortColumn: column,
        sortAscending: ascending,
        currentPage: 0,
      ));
    }
  }
}
