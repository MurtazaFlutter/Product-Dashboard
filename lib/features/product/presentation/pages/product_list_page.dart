import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/core/constants/app_constants.dart';
import 'package:interview_test/features/product/presentation/bloc/product_bloc.dart';
import 'package:interview_test/features/product/presentation/bloc/product_event.dart';
import 'package:interview_test/features/product/presentation/bloc/product_state.dart';
import 'package:interview_test/features/product/presentation/widgets/product_data_table.dart';
import 'package:interview_test/features/product/presentation/widgets/product_form_dialog.dart';
import 'package:interview_test/features/theme/presentation/widgets/theme_switcher.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 500) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Products',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Row(
                            children: [
                              const ThemeSwitcher(),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const ProductFormDialog(),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Product'),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Products',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const ThemeSwitcher(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const ProductFormDialog(),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Product'),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          context.read<ProductBloc>().add(const SearchProducts(''));
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                context.read<ProductBloc>().add(SearchProducts(value));
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                prefixIcon: Icon(Icons.filter_list),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCategory,
                                  isExpanded: true,
                                  items: AppConstants.categories
                                      .map((category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value!;
                                    });
                                    context.read<ProductBloc>().add(FilterProductsByCategory(value!));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        context.read<ProductBloc>().add(const SearchProducts(''));
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              context.read<ProductBloc>().add(SearchProducts(value));
                            },
                          ),
                          const SizedBox(height: 16),
                          InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.filter_list),
                              border: OutlineInputBorder(),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                items: AppConstants.categories
                                    .map((category) => DropdownMenuItem(
                                          value: category,
                                          child: Text(category),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                  context.read<ProductBloc>().add(FilterProductsByCategory(value!));
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ProductOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  if (state.filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Card(
                              child: ProductDataTable(
                                products: state.paginatedProducts,
                                onDelete: (id) {
                                  context.read<ProductBloc>().add(DeleteProduct(id));
                                },
                                sortColumn: state.sortColumn,
                                sortAscending: state.sortAscending,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildPaginationControls(context, state),
                    ],
                  );
                } else if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductBloc>().add(LoadProducts());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(BuildContext context, ProductLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            // Mobile layout - stack controls vertically
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Rows per page:'),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: state.itemsPerPage,
                          items: const [
                            DropdownMenuItem(value: 5, child: Text('5')),
                            DropdownMenuItem(value: 10, child: Text('10')),
                            DropdownMenuItem(value: 25, child: Text('25')),
                            DropdownMenuItem(value: 50, child: Text('50')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ProductBloc>().add(ChangeItemsPerPage(value));
                            }
                          },
                        ),
                      ],
                    ),
                    Flexible(
                      child: Text(
                        '${state.currentPage * state.itemsPerPage + 1}-${((state.currentPage + 1) * state.itemsPerPage).clamp(0, state.filteredProducts.length)} of ${state.filteredProducts.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.first_page),
                      onPressed: state.currentPage > 0
                          ? () => context.read<ProductBloc>().add(const ChangePage(0))
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: state.currentPage > 0
                          ? () => context.read<ProductBloc>().add(ChangePage(state.currentPage - 1))
                          : null,
                    ),
                    Text(
                      'Page ${state.currentPage + 1} of ${state.totalPages.clamp(1, double.infinity).toInt()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: state.currentPage < state.totalPages - 1
                          ? () => context.read<ProductBloc>().add(ChangePage(state.currentPage + 1))
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.last_page),
                      onPressed: state.currentPage < state.totalPages - 1
                          ? () => context.read<ProductBloc>().add(ChangePage(state.totalPages - 1))
                          : null,
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Desktop layout - horizontal
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('Rows per page:'),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: state.itemsPerPage,
                        items: const [
                          DropdownMenuItem(value: 5, child: Text('5')),
                          DropdownMenuItem(value: 10, child: Text('10')),
                          DropdownMenuItem(value: 25, child: Text('25')),
                          DropdownMenuItem(value: 50, child: Text('50')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            context.read<ProductBloc>().add(ChangeItemsPerPage(value));
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          '${state.currentPage * state.itemsPerPage + 1}-${((state.currentPage + 1) * state.itemsPerPage).clamp(0, state.filteredProducts.length)} of ${state.filteredProducts.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.first_page),
                      onPressed: state.currentPage > 0
                          ? () => context.read<ProductBloc>().add(const ChangePage(0))
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: state.currentPage > 0
                          ? () => context.read<ProductBloc>().add(ChangePage(state.currentPage - 1))
                          : null,
                    ),
                    Text(
                      'Page ${state.currentPage + 1} of ${state.totalPages.clamp(1, double.infinity).toInt()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: state.currentPage < state.totalPages - 1
                          ? () => context.read<ProductBloc>().add(ChangePage(state.currentPage + 1))
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.last_page),
                      onPressed: state.currentPage < state.totalPages - 1
                          ? () => context.read<ProductBloc>().add(ChangePage(state.totalPages - 1))
                          : null,
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
