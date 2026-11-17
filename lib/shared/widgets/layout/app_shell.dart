import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../../features/auth/domain/auth_state.dart';
import '../../../shared/models/user.dart';
import '../../../shared/widgets/brand/app_logo.dart';
import '../../../main.dart';
import 'navigation_menu.dart';
import 'top_app_bar.dart';

/// Responsive App Shell that adapts to different screen sizes
/// - Mobile/Portrait: Bottom Navigation + Drawer
/// - Desktop/Landscape: Persistent Sidebar + Top Bar
class AppShell extends StatefulWidget {
  const AppShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSidebarExpanded = false;

  @override
  void initState() {
    super.initState();
    // Initialize sidebar state based on screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isSidebarExpanded = !Responsive.shouldCollapseSidebar(context);
      });
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );

    // Close drawer on mobile after navigation
    if (Responsive.isMobile(context) && _scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          context.go('/login');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (!authState.isAuthenticated) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = authState.user!;
          final isMobile = Responsive.isMobile(context);
          final isTablet = Responsive.isTablet(context);

          if (isMobile) {
            return _buildMobileLayout(user);
          } else if (isTablet) {
            return _buildTabletLayout(user);
          } else {
            return _buildDesktopLayout(user);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(User user) {
    final bottomNavDestinations = NavigationMenu.getBottomNavDestinations(user.role);
    
    // Ensure destinations list is not empty
    if (bottomNavDestinations.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No navigation destinations available')),
      );
    }
    
    // Clamp the selected index to valid bottom nav range
    // Bottom nav only shows first 5 items, but shell can have more routes
    final currentIndex = widget.navigationShell.currentIndex;
    final maxIndex = bottomNavDestinations.length - 1;
    final bottomNavIndex = currentIndex < 0 ? 0 : (currentIndex > maxIndex ? maxIndex : currentIndex);
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopAppBar(
        user: user,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        showMenuButton: true,
      ),
      drawer: NavigationDrawer(
        user: user,
        currentIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomNavIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: bottomNavDestinations,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  Widget _buildTabletLayout(User user) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopAppBar(
        user: user,
        onMenuPressed: _toggleSidebar,
        showMenuButton: true,
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarExpanded ? Responsive.getSidebarWidth(context) : 72,
            child: NavigationRail(
              extended: _isSidebarExpanded,
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: NavigationMenu.getRailDestinations(user.role),
              leading: _isSidebarExpanded ? null : const SizedBox(height: 16),
              trailing: _isSidebarExpanded 
                ? Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildUserProfile(user, compact: false),
                      ),
                    ),
                  )
                : null,
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.navigationShell),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(User user) {
    return Scaffold(
      appBar: TopAppBar(
        user: user,
        onMenuPressed: _toggleSidebar,
        showMenuButton: false,
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarExpanded ? Responsive.getSidebarWidth(context) : 72,
            child: NavigationSidebar(
              user: user,
              expanded: _isSidebarExpanded,
              currentIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.navigationShell),
        ],
      ),
    );
  }

  Widget _buildUserProfile(User user, {required bool compact}) {
    if (compact) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          user.initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.role.displayName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Navigation Drawer for mobile
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({
    required this.user,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final User user;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final destinations = NavigationMenu.getDrawerDestinations(user.role);

    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E1B4B), Color(0xFF4F46E5)],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.initials,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    user.role.displayName,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                final selected = index == currentIndex;
                return ListTile(
                  leading: Icon(selected ? destination.selectedIcon : destination.icon),
                  title: Text(destination.label),
                  selected: selected,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () => onDestinationSelected(index),
                );
              },
            ),
          ),
          // Logout button
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Desktop Navigation Sidebar
class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({
    required this.user,
    required this.expanded,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final User user;
  final bool expanded;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final destinations = NavigationMenu.getSidebarDestinations(user.role);

    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(expanded ? 16 : 12, 24, expanded ? 16 : 12, 20),
            child: expanded
                ? const AppLogo(size: 40, showWordmark: true)
                : const AppLogo(size: 40),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                final isSelected = index == currentIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Material(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => onDestinationSelected(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border(
                                  left: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 3,
                                  ),
                                )
                              : null,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: expanded ? 12 : 0,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: expanded
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected ? destination.selectedIcon : destination.icon,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.65),
                            ),
                            if (expanded) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  destination.label,
                                  style: TextStyle(
                                    color: isSelected ? theme.colorScheme.primary : null,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // User profile section
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: expanded
              ? Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            user.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: Theme.of(context).textTheme.labelLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user.role.displayName,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Sign Out'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        user.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      tooltip: 'Sign Out',
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}