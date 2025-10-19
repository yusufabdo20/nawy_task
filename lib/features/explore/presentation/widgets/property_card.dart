import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nawy_task/core/constants/app_strings.dart';
import 'package:nawy_task/features/shared/presentation/theme/app_theme.dart';

class PropertyCardWidget extends StatelessWidget {
  // Property data
  final String? imageUrl;
  final String propertyType;
  final String? propertyName;
  final String deliveryYear;
  final double price;
  final double monthlyPayment;
  final int paymentYears;
  final String compound;
  final String location;
  final int bedrooms;
  final int bathrooms;
  final String area;
  
  // Developer/Company info
  final String? developerName;
  final String? developerLogo;
  
  // Favorite state
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  
  // Action callbacks
  final VoidCallback? onZoom;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsapp;
  final VoidCallback? onTap;

  const PropertyCardWidget({
    super.key,
    this.imageUrl,
    required this.propertyType,
     this.propertyName,
    required this.deliveryYear,
    required this.price,
    required this.monthlyPayment,
    required this.paymentYears,
    required this.compound,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    this.developerName,
    this.developerLogo,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onZoom,
    this.onCall,
    this.onWhatsapp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image section with overlays
            _buildImageSection(context),
            
            // Content section
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          child: Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildShimmerPlaceholder(),
                    errorWidget: (context, url, error) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          ),
        ),
        
        if (developerLogo != null || developerName != null)
          Positioned(
            top: 0.h,
            right: 15.w,
            child: _buildDeveloperBadge(),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.3),
            const Color(0xFF6B5846).withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.home_work_outlined,
          size: 64.w,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildDeveloperBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.r),bottomRight: Radius.circular(8.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: developerLogo!,
        width: 80.w,
        height: 80.h,
        placeholder: (context, url) => _buildDeveloperLogoShimmer(),
        errorWidget: (context, url, error) => Icon(
          Icons.business,
          size: 16.w,
          color: AppTheme.primaryColor,
        ),
      ),
    
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property type and delivery year
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  propertyName??"",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                   
                  ),
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Delivery $deliveryYear',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600]!,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          // Price with favorite icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EGP ${_formatPrice(price)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentColor,
                ),
              ),
              GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite 
                      ? AppTheme.accentColor
                      : const Color(0xFFBDBDBD),
                  size: 20.w,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4.h),
          
          // Monthly payment
          Text(
            '${_formatPrice(monthlyPayment)} EGP/month over $paymentYears years',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600]!,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.w,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600]!,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  '$compound - $location',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600]!,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Property specifications
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSpecChip(context, Icons.bed_outlined, bedrooms.toString()),
              SizedBox(width: 16.w),
              _buildSpecChip(context, Icons.bathtub_outlined, bathrooms.toString()),
              SizedBox(width: 16.w),
              _buildSpecChip(context, Icons.square_foot_outlined, '${area}m²'),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: AppStrings.zoom.tr(),
                  icon: Icons.videocam,
                  onPressed: onZoom,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: AppStrings.call.tr(),
                  icon: Icons.phone,
                  onPressed: onCall,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: AppStrings.whatsapp.tr(),
                  icon: Icons.whatshot,
                  onPressed: onWhatsapp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecChip(BuildContext context, IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24.w,
          color:  AppTheme.primaryColor,
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: const BorderSide(
          color: AppTheme.primaryColor,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        minimumSize: Size(0, 36.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.w, color: AppTheme.primaryColor),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(price % 1000000 == 0 ? 0 : 1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
    }
    return price.toStringAsFixed(0);
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _buildDeveloperLogoShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
