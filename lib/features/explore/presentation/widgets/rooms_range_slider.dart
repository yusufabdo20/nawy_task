import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nawy_task/core/constants/app_strings.dart';

class RoomsRangeSlider extends StatelessWidget {
  final int minRooms;
  final int maxRooms;
  final int? selectedMinRooms;
  final int? selectedMaxRooms;
  final ValueChanged<int?> onMinRoomsChanged;
  final ValueChanged<int?> onMaxRoomsChanged;
  final String label;
  final List<Map<String, dynamic>>? quickOptions;

  const RoomsRangeSlider({
    super.key,
    required this.minRooms,
    required this.maxRooms,
    this.selectedMinRooms,
    this.selectedMaxRooms,
    required this.onMinRoomsChanged,
    required this.onMaxRoomsChanged,
    this.label = 'Bedrooms',
    this.quickOptions,
  });

  @override
  Widget build(BuildContext context) {
    final currentMinRooms = selectedMinRooms ?? minRooms;
    final currentMaxRooms = selectedMaxRooms ?? maxRooms;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _getRoomsText(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Single Range Slider
          _buildRangeSlider(context, currentMinRooms, currentMaxRooms),
          
          SizedBox(height: 8.h),
          
          // Quick selection buttons
          _buildQuickSelectionButtons(context),
        ],
      ),
    );
  }

  Widget _buildRangeSlider(BuildContext context, int currentMinRooms, int currentMaxRooms) {
    return Column(
      children: [
        // Range values display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppStrings.min.tr()}: $currentMinRooms',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${AppStrings.max.tr()}: $currentMaxRooms',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        
        // Range Slider
        RangeSlider(
          values: RangeValues(
            currentMinRooms.toDouble(),
            currentMaxRooms.toDouble(),
          ),
          min: minRooms.toDouble(),
          max: maxRooms.toDouble(),
          divisions: maxRooms - minRooms,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Colors.grey[300],
          onChanged: (RangeValues values) {
            onMinRoomsChanged(values.start.round());
            onMaxRoomsChanged(values.end.round());
          },
        ),
      ],
    );
  }

  Widget _buildQuickSelectionButtons(BuildContext context) {
    final options = quickOptions ?? _getDefaultQuickOptions();

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = _isQuickOptionSelected(option);
        return GestureDetector(
          onTap: () {
            onMinRoomsChanged(option['min'] as int?);
            onMaxRoomsChanged(option['max'] as int?);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Text(
              option['label'] as String,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isQuickOptionSelected(Map<String, dynamic> option) {
    final optionMin = option['min'] as int?;
    final optionMax = option['max'] as int?;
    
    if (optionMin == null && optionMax == null) {
      return selectedMinRooms == null && selectedMaxRooms == null;
    }
    
    return selectedMinRooms == optionMin && selectedMaxRooms == optionMax;
  }

  String _getRoomsText() {
    if (selectedMinRooms == null && selectedMaxRooms == null) {
      return AppStrings.any_rooms.tr();
    }
    
    if (selectedMinRooms == selectedMaxRooms) {
      return '$selectedMinRooms';
    }
    
    if (selectedMinRooms == null) {
      return 'Up to $selectedMaxRooms';
    }
    
    if (selectedMaxRooms == null) {
      return '$selectedMinRooms+';
    }
    
    return '$selectedMinRooms - $selectedMaxRooms';
  }

  List<Map<String, dynamic>> _getDefaultQuickOptions() {
    return [
      {'label': AppStrings.any_rooms.tr(), 'min': null, 'max': null},
      {'label': '1-2', 'min': 1, 'max': 2},
      {'label': '2-3', 'min': 2, 'max': 3},
      {'label': '3-4', 'min': 3, 'max': 4},
      {'label': '4-5', 'min': 4, 'max': 5},
      {'label': '5+', 'min': 5, 'max': null},
    ];
  }
}