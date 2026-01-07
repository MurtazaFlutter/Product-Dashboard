import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_test/core/constants/app_constants.dart';
import 'package:interview_test/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:interview_test/features/auth/presentation/bloc/auth_event.dart';
import 'package:interview_test/features/auth/presentation/bloc/auth_state.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _isDrawerOpen = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.appName),
            leading: IconButton(
              icon: Icon(_isDrawerOpen ? Icons.menu_open : Icons.menu),
              onPressed: () {
                setState(() {
                  _isDrawerOpen = !_isDrawerOpen;
                });
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return PopupMenuButton<String>(
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          state.userName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      itemBuilder: (context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          enabled: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.userName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                state.userEmail,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: const Row(
                            children: [
                              Icon(Icons.logout, size: 20),
                              SizedBox(width: 12),
                              Text('Logout'),
                            ],
                          ),
                          onTap: () {
                            context.read<AuthBloc>().add(LogoutRequested());
                          },
                        ),
                      ],
                    );
                  }
                  return CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.person),
                  );
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Stack(
            children: [
              Row(
                children: [
                  if (isWideScreen && _isDrawerOpen)
                    _buildSidebar(context),
                  Expanded(
                    child: widget.child,
                  ),
                ],
              ),
              if (!isWideScreen && _isDrawerOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDrawerOpen = false;
                      });
                    },
                    child: Container(
                      color: Colors.black54,
                      child: GestureDetector(
                        onTap: () {},
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 250,
                            child: _buildSidebar(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildNavItem(
            context,
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            label: 'Dashboard',
            path: '/',
            isSelected: currentLocation == '/',
          ),
          _buildNavItem(
            context,
            icon: Icons.inventory_2_outlined,
            selectedIcon: Icons.inventory_2,
            label: 'Products',
            path: '/',
            isSelected: currentLocation == '/' || currentLocation.startsWith('/products'),
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'SETTINGS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: 'Settings',
            path: '/settings',
            isSelected: currentLocation == '/settings',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required String path,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () => context.go(path),
      ),
    );
  }
}
