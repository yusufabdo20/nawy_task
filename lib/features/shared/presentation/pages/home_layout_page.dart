import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:nawy_task/core/constants/app_strings.dart';
import 'package:nawy_task/features/explore/presentation/pages/explore_page.dart';
import 'package:nawy_task/features/favorites/presentation/pages/favorites_page.dart';
import 'package:nawy_task/features/favorites/presentation/services/favorites_service.dart';
import 'package:nawy_task/features/shared/presentation/pages/updates_page.dart';
import 'package:nawy_task/features/shared/presentation/pages/more_page.dart';

class HomeLayoutPage extends StatefulWidget {
  const HomeLayoutPage({super.key});

  @override
  State<HomeLayoutPage> createState() => HomeLayoutPageState();
}

class HomeLayoutPageState extends State<HomeLayoutPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load favorites when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesService>().loadFavorites();
    });
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get views => [
    const ExplorePage(),
    const UpdatesPage(),
    FavoritesPage(key: favoritesPageKey),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // appBar: AppBar(
      //   title: Text(AppConstants.appBarTitles[_currentIndex].tr()),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   foregroundColor: Colors.black,
      // ),
      body: IndexedStack(index: _currentIndex, children: views),
      bottomNavigationBar: Consumer<FavoritesService>(
        builder: (context, favoritesService, child) {
          final favoritesCount = favoritesService.favoriteIds.length;
          
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              
              // Refresh favorites when favorites tab is tapped
              if (index == 2) { // Favorites tab index
                favoritesPageKey.currentState?.refreshFavorites();
              }
            },
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.search_outlined),
                activeIcon: const Icon(Icons.search),
                label: AppStrings.explore.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_outlined),
                activeIcon: const Icon(Icons.dashboard),
                label: AppStrings.updates.tr(),
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.favorite_outline),
                    if (favoritesCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            favoritesCount > 99 ? '99+' : favoritesCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                activeIcon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.favorite),
                    if (favoritesCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                         child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            favoritesCount > 99 ? '99+' : favoritesCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: AppStrings.favorites.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.more_horiz_outlined),
                activeIcon: const Icon(Icons.more_horiz),
                label: AppStrings.more.tr(),
              ),
            ],
          );
        },
      ),
    );
  }
}
