import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';
import 'package:nawy_task/features/explore/presentation/widgets/property_card.dart';
import 'package:nawy_task/features/favorites/presentation/services/favorites_service.dart';
import 'package:nawy_task/core/constants/app_strings.dart';

class ResultsPage extends StatelessWidget {
  final List<Property> properties;
  final String? searchQuery;
  final String? priceRange;
  final String? roomsRange;

  const ResultsPage({
    super.key,
    required this.properties,
    this.searchQuery,
    this.priceRange,
    this.roomsRange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.search_results.tr()} (${properties.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18.sp,
              ),
            ),
            if (searchQuery != null || priceRange != null || roomsRange != null)
              Text(
                _buildFilterSummary(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: properties.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                if (searchQuery != null || priceRange != null || roomsRange != null) _buildFilterChips(context),
                Expanded(child: _buildResultsList()),
              ],
            ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Theme.of(context).cardTheme.color,
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 16.w,
            color: Colors.grey[600],
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (searchQuery != null && searchQuery!.isNotEmpty)
                    _buildFilterChip(context, 'Search: "$searchQuery"', Icons.search),
                  if (priceRange != null && priceRange!.isNotEmpty)
                    _buildFilterChip(context, 'Price: $priceRange', Icons.attach_money),
                  if (roomsRange != null && roomsRange!.isNotEmpty)
                    _buildFilterChip(context, 'Rooms: $roomsRange', Icons.bed),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.w,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _buildFilterSummary() {
    final filters = <String>[];
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      filters.add('Search: "$searchQuery"');
    }
    if (priceRange != null && priceRange!.isNotEmpty) {
      filters.add('Price: $priceRange');
    }
    if (roomsRange != null && roomsRange!.isNotEmpty) {
      filters.add('Rooms: $roomsRange');
    }
    return filters.join(' • ');
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.no_results.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.try_adjusting_criteria.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            if (searchQuery != null || priceRange != null || roomsRange != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    Text(
                      AppStrings.applied_filters.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _buildFilterSummary(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.edit),
              label: Text(AppStrings.modify_search.tr()),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return Consumer<FavoritesService>(
      builder: (context, favoritesService, child) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            final propertyId = 'property_${property.id}';
            final isFavorite = favoritesService.isFavorite(propertyId);
            
            return PropertyCardWidget(
              imageUrl: property.imageUrl,
              propertyType: property.propertyType ?? 'Unknown',
              propertyName: property.name,
              deliveryYear: property.deliveryYear ?? 'N/A',
              price: property.price ?? 0.0,
              monthlyPayment: property.monthlyPayment ?? 0.0,
              paymentYears: property.paymentYears?.toInt() ?? 0,
              compound: property.compound ?? 'Unknown',
              location: property.location ?? 'Unknown',
              bedrooms: property.bedrooms?.toInt() ?? 0,
              bathrooms: property.bathrooms?.toInt() ?? 0,
              area: property.area ?? 'Unknown',
              developerName: property.developerName,
              developerLogo: property.developerLogo,
              isFavorite: isFavorite,
              onFavoriteToggle: () async {
                final success = await favoritesService.togglePropertyFavorite(property);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success 
                            ? AppStrings.added_to_favorites.tr()
                            : AppStrings.removed_from_favorites.tr(),
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: success 
                          ? Colors.green[600] 
                          : Colors.orange[600],
                    ),
                  );
                }
              },
              onZoom: () {
                // TODO: Implement zoom functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.zoom_not_implemented.tr()),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onCall: () {
                // TODO: Implement call functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.call_not_implemented.tr()),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onWhatsapp: () {
                // TODO: Implement WhatsApp functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.whatsapp_not_implemented.tr()),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onTap: () {
                // TODO: Navigate to property details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.property_details_not_implemented.tr()),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
