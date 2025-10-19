import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nawy_task/core/constants/app_constants.dart';
import 'package:nawy_task/core/errors/exceptions.dart';
import 'package:nawy_task/features/favorites/domain/entities/favorite_item.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteItem>> getFavorites();
  Future<void> addFavorite(FavoriteItem favorite);
  Future<void> removeFavorite(String favoriteId);
  Future<bool> isFavorite(String favoriteId);
  Future<void> clearFavorites();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;

  const FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FavoriteItem>> getFavorites() async {
    try {
      final favoritesJson = sharedPreferences.getStringList(AppConstants.favoritesKey);
      if (favoritesJson == null || favoritesJson.isEmpty) {
        return [];
      }

      final favorites = favoritesJson
          .map((jsonString) => FavoriteItem.fromJson(jsonDecode(jsonString)))
          .toList();
      return favorites;
    } catch (e) {
      throw CacheException(message: 'Failed to get favorites: $e');
    }
  }

  @override
  Future<void> addFavorite(FavoriteItem favorite) async {
    try {
      final favorites = await getFavorites();
      
      // Check if already exists
      if (favorites.any((f) => f.id == favorite.id)) {
        return; // Already exists, no need to add
      }

      favorites.add(favorite);
      await _saveFavorites(favorites);
    } catch (e) {
      throw CacheException(message: 'Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(String favoriteId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((favorite) => favorite.id == favoriteId);
      await _saveFavorites(favorites);
    } catch (e) {
      throw CacheException(message: 'Failed to remove favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite(String favoriteId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((favorite) => favorite.id == favoriteId);
    } catch (e) {
      throw CacheException(message: 'Failed to check if favorite: $e');
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      await sharedPreferences.remove(AppConstants.favoritesKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear favorites: $e');
    }
  }

  Future<void> _saveFavorites(List<FavoriteItem> favorites) async {
    final favoritesJson = favorites
        .map((favorite) => jsonEncode(favorite.toJson()))
        .toList();
    
    await sharedPreferences.setStringList(AppConstants.favoritesKey, favoritesJson);
  }
}
