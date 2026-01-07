import 'package:dartz/dartz.dart';
import 'package:interview_test/core/errors/failures.dart';
import 'package:interview_test/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, Product>> addProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(int id);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
