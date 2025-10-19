import 'package:flutter/foundation.dart';
import 'package:nawy_task/features/favorites/domain/entities/favorite_item.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart' as domain_compound;
import 'package:nawy_task/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:nawy_task/features/favorites/domain/usecases/check_favorite_usecase.dart';
import 'package:nawy_task/features/favorites/domain/usecases/get_favorites_usecase.dart';

class FavoritesService extends ChangeNotifier {
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final CheckFavoriteUseCase _checkFavoriteUseCase;
  final GetFavoritesUseCase _getFavoritesUseCase;

  Set<String> _favoriteIds = {};
  bool _isLoaded = false;
  bool _isLoading = false;

  FavoritesService({
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required CheckFavoriteUseCase checkFavoriteUseCase,
    required GetFavoritesUseCase getFavoritesUseCase,
  })  : _toggleFavoriteUseCase = toggleFavoriteUseCase,
        _checkFavoriteUseCase = checkFavoriteUseCase,
        _getFavoritesUseCase = getFavoritesUseCase;

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  bool get isLoaded => _isLoaded;

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> loadFavorites() async {
    if (_isLoading || _isLoaded) return; // Prevent duplicate calls
    
    _isLoading = true;
    final result = await _getFavoritesUseCase();
    result.fold(
      (failure) {
        _isLoading = false;
        debugPrint('Failed to load favorites: ${failure.message}');
      },
      (favorites) {
        _favoriteIds = favorites.map((f) => f.id).toSet();
        _isLoaded = true;
        _isLoading = false;
        debugPrint('Loaded ${favorites.length} favorites: $_favoriteIds');
        notifyListeners();
      },
    );
  }

  Future<bool> togglePropertyFavorite(Property property) async {
    final favorite = FavoriteItem.fromProperty(
      propertyId: property.id?.toString() ?? '',
      name: property.name ?? 'Unknown Property',
      imageUrl: property.imageUrl,
      slug: property.slug,
      metadata: {
        'propertyType': property.propertyType,
        'price': property.price,
        'compound': property.compound,
        'location': property.location,
        'bedrooms': property.bedrooms,
        'bathrooms': property.bathrooms,
        'area': property.area,
      },
    );

    return await _toggleFavorite(favorite);
  }

  Future<bool> toggleCompoundFavorite(domain_compound.Compound compound) async {
    final favorite = FavoriteItem.fromCompound(
      compoundId: compound.id?.toString() ?? '',
      name: compound.name ?? 'Unknown Compound',
      imageUrl: compound.imagePath,
      slug: compound.slug,
      metadata: {
        'areaName': compound.areaName,
        'hasOffers': compound.hasOffers,
      },
    );

    return await _toggleFavorite(favorite);
  }

  Future<bool> _toggleFavorite(FavoriteItem favorite) async {
    final result = await _toggleFavoriteUseCase(favorite);
    
    return result.fold(
      (failure) {
        debugPrint('Failed to toggle favorite: ${failure.message}');
        return false;
      },
      (isNowFavorite) {
        if (isNowFavorite) {
          _favoriteIds.add(favorite.id);
        } else {
          _favoriteIds.remove(favorite.id);
        }
        // Mark as modified so we know to refresh the full list
        _isLoaded = false;
        notifyListeners();
        return isNowFavorite;
      },
    );
  }

  Future<void> checkPropertyFavorite(Property property) async {
    final favoriteId = 'property_${property.id}';
    await _checkFavorite(favoriteId);
  }

  Future<void> checkCompoundFavorite(domain_compound.Compound compound) async {
    final favoriteId = 'compound_${compound.id}';
    await _checkFavorite(favoriteId);
  }

  Future<void> _checkFavorite(String favoriteId) async {
    final result = await _checkFavoriteUseCase(favoriteId);
    
    result.fold(
      (failure) {
        debugPrint('Failed to check favorite: ${failure.message}');
      },
      (isFavorite) {
        if (isFavorite) {
          _favoriteIds.add(favoriteId);
        } else {
          _favoriteIds.remove(favoriteId);
        }
        notifyListeners();
      },
    );
  }
}
