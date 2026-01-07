import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:interview_test/core/constants/api_constants.dart';
import 'package:interview_test/features/product/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(int id);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(int id);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}?limit=${ApiConstants.productsLimit}',
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> products = jsonResponse['products'];
      return products.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      final errorMessage = _parseErrorMessage(response.body);
      throw Exception('Failed to load products: $errorMessage');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      final errorMessage = _parseErrorMessage(response.body);
      throw Exception('Failed to load product: $errorMessage');
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    log("Add product API response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      final errorMessage = _parseErrorMessage(response.body);
      throw Exception('Failed to add product: $errorMessage');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    log("Updating product with ID: ${product.id}");
    log("Update request body: ${json.encode(product.toJson())}");

    final response = await client.put(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/${product.id}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    log("Update product API response status: ${response.statusCode}");
    log("Update product API response body: ${response.body}");

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      final errorMessage = _parseErrorMessage(response.body);
      throw Exception('Failed to update product with ID ${product.id}: $errorMessage');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id'),
    );
    log("Delete product API response: ${response.body}");

    if (response.statusCode != 200) {
      final errorMessage = _parseErrorMessage(response.body);
      throw Exception('Failed to delete product with ID $id: $errorMessage');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/search?q=$query',
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> products = jsonResponse['products'];
      return products.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      final errorMessage = _parseErrorMessage(response.body);
      throw Exception('Failed to search products: $errorMessage');
    }
  }

  String _parseErrorMessage(String responseBody) {
    try {
      final jsonResponse = json.decode(responseBody);
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('message')) {
        return jsonResponse['message'];
      }
      return responseBody;
    } catch (e) {
      return responseBody;
    }
  }
}
