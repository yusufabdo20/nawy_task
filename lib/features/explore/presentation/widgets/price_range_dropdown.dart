import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceRangeDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<Map<String, dynamic>> priceRanges;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const PriceRangeDropdown({
    super.key,
    required this.selectedValue,
    required this.priceRanges,
    required this.onChanged,
    this.hintText = 'Select Price Range',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              hintText,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          isExpanded: true,
          icon: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
          ),
          items: priceRanges.asMap().entries.map((entry) {
            final index = entry.key;
            final range = entry.value;
            return DropdownMenuItem<String>(
              value: '${range['min']}_${range['max']}_$index', 
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  range['label'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
