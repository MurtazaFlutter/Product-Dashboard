import 'package:equatable/equatable.dart';
import 'package:interview_test/features/product/domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterProductsByCategory extends ProductEvent {
  final String category;

  const FilterProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class AddProduct extends ProductEvent {
  final Product product;

  const AddProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final Product product;

  const UpdateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final int productId;

  const DeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

class GetProductById extends ProductEvent {
  final int productId;

  const GetProductById(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ChangePage extends ProductEvent {
  final int page;

  const ChangePage(this.page);

  @override
  List<Object?> get props => [page];
}

class ChangeItemsPerPage extends ProductEvent {
  final int itemsPerPage;

  const ChangeItemsPerPage(this.itemsPerPage);

  @override
  List<Object?> get props => [itemsPerPage];
}

class SortProducts extends ProductEvent {
  final String column;

  const SortProducts(this.column);

  @override
  List<Object?> get props => [column];
}
