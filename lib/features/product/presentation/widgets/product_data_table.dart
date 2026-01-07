import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_test/features/product/domain/entities/product.dart';
import 'package:interview_test/features/product/presentation/bloc/product_bloc.dart';
import 'package:interview_test/features/product/presentation/bloc/product_event.dart';
import 'package:interview_test/features/product/presentation/widgets/product_form_dialog.dart';

class ProductDataTable extends StatelessWidget {
  final List<Product> products;
  final Function(int) onDelete;
  final String sortColumn;
  final bool sortAscending;

  const ProductDataTable({
    super.key,
    required this.products,
    required this.onDelete,
    this.sortColumn = '',
    this.sortAscending = true,
  });

  DataColumn _buildSortableColumn(BuildContext context, String label, String columnKey) {
    return DataColumn(
      label: Text(label),
      onSort: (columnIndex, ascending) {
        context.read<ProductBloc>().add(SortProducts(columnKey));
      },
    );
  }

  int? _getSortColumnIndex() {
    switch (sortColumn) {
      case 'id':
        return 0;
      case 'title':
        return 2;
      case 'category':
        return 3;
      case 'price':
        return 4;
      case 'stock':
        return 5;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 30,
        horizontalMargin: 20,
        sortColumnIndex: _getSortColumnIndex(),
        sortAscending: sortAscending,
        columns: [
          _buildSortableColumn(context, 'ID', 'id'),
          const DataColumn(label: Text('Image')),
          _buildSortableColumn(context, 'Name', 'title'),
          _buildSortableColumn(context, 'Category', 'category'),
          _buildSortableColumn(context, 'Price', 'price'),
          _buildSortableColumn(context, 'Stock', 'stock'),
          const DataColumn(label: Text('Status')),
          const DataColumn(label: Text('Actions')),
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(Text('#${product.id}')),
              DataCell(
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    product.thumbnail,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 20),
                      );
                    },
                  ),
                ),
              ),
              DataCell(
                InkWell(
                  onTap: () => context.go('/products/${product.id}'),
                  child: Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              DataCell(Text(product.category)),
              DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
              DataCell(Text('${product.stock}')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.isInStock ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.stockStatus,
                    style: TextStyle(
                      color: product.isInStock ? Colors.green.shade900 : Colors.red.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      tooltip: 'View',
                      onPressed: () => context.go('/products/${product.id}'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      tooltip: 'Edit',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ProductFormDialog(product: product),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Product'),
                            content: Text('Are you sure you want to delete "${product.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  onDelete(product.id);
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
