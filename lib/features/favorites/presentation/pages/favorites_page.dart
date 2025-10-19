import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nawy_task/core/di/injection_container.dart';
import 'package:nawy_task/core/constants/app_strings.dart';
import 'package:nawy_task/features/favorites/domain/entities/favorite_item.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart' as domain_compound;
import 'package:nawy_task/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:nawy_task/features/favorites/presentation/services/favorites_service.dart';
import 'package:nawy_task/features/explore/presentation/widgets/property_card.dart';
import 'package:nawy_task/features/explore/presentation/widgets/compound_card.dart';
import 'package:nawy_task/features/shared/presentation/pages/home_layout_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

// Global key to access FavoritesPage state
final GlobalKey<_FavoritesPageState> favoritesPageKey = GlobalKey<_FavoritesPageState>();

class _FavoritesPageState extends State<FavoritesPage> {
  late FavoritesService _favoritesService;
  late GetFavoritesUseCase _getFavoritesUseCase;
  List<FavoriteItem> _favorites = [];
  bool _isLoading = true;
  bool _isLoadingFavorites = false; // Prevent duplicate calls

  // Method to refresh favorites from outside
  void refreshFavorites() {
    if (!_isLoadingFavorites) {
      _loadFavorites();
    }
  }

  @override
  void initState() {
    super.initState();
    _favoritesService = sl<FavoritesService>();
    _getFavoritesUseCase = sl<GetFavoritesUseCase>();
    _loadFavorites();
    
    // Listen to favorites service changes
    _favoritesService.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesService.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    // Reload favorites when the service notifies of changes
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (_isLoadingFavorites) return; // Prevent duplicate calls
    
    setState(() {
      _isLoading = true;
      _isLoadingFavorites = true;
    });

    try {
      // Only load from service if not already loaded
      if (!_favoritesService.isLoaded) {
        await _favoritesService.loadFavorites();
      }
      
      // Get favorites from the service
      final result = await _getFavoritesUseCase();
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${AppStrings.failed_to_load_favorites.tr()}: ${failure.message}'),
                backgroundColor: Colors.red[600],
              ),
            );
          }
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isLoadingFavorites = false;
            });
          }
        },
        (favorites) {
          if (mounted) {
            setState(() {
              _favorites = favorites;
              _isLoading = false;
              _isLoadingFavorites = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingFavorites = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.my_favorites.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
            tooltip: 'Refresh',
          ),
          if (_favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _showClearAllDialog,
              tooltip: AppStrings.clear_all_favorites.tr(),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.noFavorites.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.favoritesEmptyMessage.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => _navigateToExplorePage(context),
            icon: const Icon(Icons.explore),
            label: Text(AppStrings.start_exploring.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
       
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final favorite = _favorites[index];
        
        if (favorite.type == FavoriteType.property) {
          return _buildPropertyCard(favorite);
        } else {
          return _buildCompoundCard(favorite);
        }
      },
    );
  }

  Widget _buildPropertyCard(FavoriteItem favorite) {
    final metadata = favorite.metadata ?? {};
    
    return PropertyCardWidget(
      imageUrl: favorite.imageUrl,
      propertyType: metadata['propertyType'] ?? 'Unknown',
      deliveryYear: 'N/A', // Not stored in metadata
      price: (metadata['price'] as num?)?.toDouble() ?? 0.0,
      monthlyPayment: 0.0, // Not stored in metadata
      paymentYears: 0, // Not stored in metadata
      compound: metadata['compound'] ?? 'Unknown',
      location: metadata['location'] ?? 'Unknown',
      bedrooms: (metadata['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (metadata['bathrooms'] as num?)?.toInt() ?? 0,
      area: metadata['area'] ?? 'Unknown',
      isFavorite: true,
      onFavoriteToggle: () => _removeFavorite(favorite),
      onZoom: () => _showNotImplemented(AppStrings.zoom_not_implemented.tr()),
      onCall: () => _showNotImplemented(AppStrings.call_not_implemented.tr()),
      onWhatsapp: () => _showNotImplemented(AppStrings.whatsapp_not_implemented.tr()),
      onTap: () => _showNotImplemented(AppStrings.property_details_not_implemented.tr()),
    );
  }

  Widget _buildCompoundCard(FavoriteItem favorite) {
    final metadata = favorite.metadata ?? {};
    
    return CompoundCardWidget(
      imageUrl: favorite.imageUrl,
      name: favorite.name,
      areaName: metadata['areaName'],
      hasOffers: metadata['hasOffers'] as bool?,
      isFavorite: true,
      onFavoriteToggle: () => _removeFavorite(favorite),
      onTap: () => _showNotImplemented(AppStrings.feature_not_implemented.tr()),
    );
  }


  Future<void> _removeFavorite(FavoriteItem favorite) async {
    final success = await _favoritesService.togglePropertyFavorite(
      // Create a dummy property for the toggle - this is a workaround
      // In a real app, you'd want to store the full property/compound data
      Property(
        id: int.tryParse(favorite.id.replaceFirst('property_', '')),
        name: favorite.name,
        imageUrl: favorite.imageUrl,
        slug: favorite.slug,
      ),
    );
    
    if (mounted) {
      setState(() {
        _favorites.removeWhere((f) => f.id == favorite.id);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success 
                ? 'Added to favorites' 
                : 'Removed from favorites',
          ),
          backgroundColor: success 
              ? Colors.green[600] 
              : Colors.orange[600],
        ),
      );
    }
  }

  void _navigateToExplorePage(BuildContext context) {
    // Find the HomeLayoutPage and change the current index to 0 (Explore tab)
    final homeLayoutState = context.findAncestorStateOfType<HomeLayoutPageState>();
    if (homeLayoutState != null) {
      homeLayoutState.changeTab(0);
    }
  }

  void _showNotImplemented(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.feature_not_implemented.tr()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.clear_all_favorites.tr()),
        content: Text(AppStrings.clear_all_confirm_message.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllFavorites();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppStrings.clear_all.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllFavorites() async {
    // Remove all favorites one by one
    for (final favorite in List.from(_favorites)) {
      if (favorite.type == FavoriteType.property) {
        await _favoritesService.togglePropertyFavorite(
          Property(
            id: int.tryParse(favorite.id.replaceFirst('property_', '')),
            name: favorite.name,
            imageUrl: favorite.imageUrl,
            slug: favorite.slug,
          ),
        );
      } else {
        await _favoritesService.toggleCompoundFavorite(
          domain_compound.Compound(
            id: int.tryParse(favorite.id.replaceFirst('compound_', '')),
            name: favorite.name,
            imagePath: favorite.imageUrl,
            slug: favorite.slug,
          ),
        );
      }
    }
    
    setState(() {
      _favorites.clear();
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.all_favorites_cleared.tr()),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
