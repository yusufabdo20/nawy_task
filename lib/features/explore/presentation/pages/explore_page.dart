import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawy_task/core/constants/app_strings.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_event.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_state.dart';
import 'package:nawy_task/features/explore/domain/entities/filter_options.dart';
import 'package:nawy_task/features/explore/presentation/pages/results_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nawy_task/features/explore/presentation/widgets/search_text_field.dart';
import 'package:nawy_task/features/explore/presentation/widgets/price_range_dropdown.dart';
import 'package:nawy_task/features/explore/presentation/widgets/rooms_range_slider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedPriceRange;
  int? _minPrice;
  int? _maxPrice;
  int? _minRooms;
  int? _maxRooms;
  
  // Dynamic filter options from API
  List<Map<String, dynamic>> _priceRanges = [];
  int _minRoomsFromAPI = 1;
  int _maxRoomsFromAPI = 10;

  @override
  void initState() {
    super.initState();
    // Load filter options when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ExploreBloc>().add(const GetFilterOptionsEvent());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.find_perfect_property.tr(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 24.sp,
                ),
              ),
                SizedBox(height: 8.h),
              Text(
                AppStrings.areaCompoundDeveloper.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
                SizedBox(height: 32.h),
                
                // Single Search Field
                SearchTextField(
                  controller: _searchController,
                  hintText: AppStrings.search_areas_compounds_developers.tr(),
                  icon: Icons.search,
                  onSearch: _performSearch,
                ),
                SizedBox(height: 16.h),
                
                // Price Range Dropdown
                BlocBuilder<ExploreBloc, ExploreState>(
                  builder: (context, state) {
                    // Update local state when filter options are loaded
                    if (state is FilterOptionsLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _updateFilterOptionsFromAPI(state.filterOptions);
                        }
                      });
                    }
                    
                    return PriceRangeDropdown(
                      selectedValue: _getCurrentPriceRangeValue(_priceRanges),
                      priceRanges: _priceRanges,
                      onChanged: _onPriceRangeChanged,
                      hintText: AppStrings.select_price_range.tr(),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                
                // Rooms Range Slider
                BlocBuilder<ExploreBloc, ExploreState>(
                  builder: (context, state) {
                    // Update local state when filter options are loaded
                    if (state is FilterOptionsLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _updateFilterOptionsFromAPI(state.filterOptions);
                        }
                      });
                    }
                    
                    return RoomsRangeSlider(
                      minRooms: _minRoomsFromAPI,
                      maxRooms: _maxRoomsFromAPI,
                      selectedMinRooms: _minRooms,
                      selectedMaxRooms: _maxRooms,
                      onMinRoomsChanged: _onMinRoomsChanged,
                      onMaxRoomsChanged: _onMaxRoomsChanged,
                      label: AppStrings.bedrooms.tr(),
                      quickOptions: _buildQuickRoomOptions(),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                
                // Search Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      AppStrings.search_properties.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Search Results
                SizedBox(
                  height: 200.h, 
                  child: BlocConsumer<ExploreBloc, ExploreState>(
                    listener: (context, state) {
                      if (state is ExploreLoaded) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ResultsPage(
                              properties: state.properties,
                              searchQuery: _searchController.text.trim(),
                              priceRange: _selectedPriceRange,
                              roomsRange: _buildRoomsRangeText(),
                            ),
                          ),
                        );
                      } else if (state is ExploreEmpty) {
                        _showSnackBar(AppStrings.no_properties_found.tr());
                      } else if (state is ExploreError) {
                        _showSnackBar('Error: ${state.message}');
                      }
                    },
                    builder: (context, state) {
                      if (state is ExploreLoading) {
                        return _buildLoadingShimmer();
                      }
                      
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    
    // Allow search even without query to test basic functionality
    
    context.read<ExploreBloc>().add(
      SearchPropertiesEvent(
        areaName: query.isNotEmpty ? query : null,
        compoundName: query.isNotEmpty ? query : null,
        developerName: query.isNotEmpty ? query : null,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minBedrooms: _minRooms,
        maxBedrooms: _maxRooms,
      ),
    );
  }

  void _updateFilterOptionsFromAPI(FilterOptions filterOptions) {
    setState(() {
      // Update price ranges from API
      if (filterOptions.priceList != null && filterOptions.priceList!.isNotEmpty) {
        _priceRanges = _buildPriceRangesFromAPI(filterOptions);
      }
      
      // Update rooms range from API
      if (filterOptions.minBedrooms != null && filterOptions.maxBedrooms != null) {
        _minRoomsFromAPI = filterOptions.minBedrooms!;
        _maxRoomsFromAPI = filterOptions.maxBedrooms!;
      }
    });
  }

  void _onPriceRangeChanged(String? value) {
    setState(() {
      _selectedPriceRange = value;
      if (value != null) {
        final parts = value.split('_');
        if (parts.length >= 2) {
          _minPrice = parts[0] == 'null' ? null : int.tryParse(parts[0]);
          _maxPrice = parts[1] == 'null' ? null : int.tryParse(parts[1]);
        } else {
          // Find the selected range from current price ranges
          final selectedRange = _priceRanges.firstWhere(
            (range) => range['label'] == value,
            orElse: () => _priceRanges.isNotEmpty ? _priceRanges.first : {'min': null, 'max': null},
          );
          _minPrice = selectedRange['min'];
          _maxPrice = selectedRange['max'];
        }
      } else {
        _minPrice = null;
        _maxPrice = null;
      }
    });
  }

  String? _getCurrentPriceRangeValue(List<Map<String, dynamic>> priceRanges) {
    if (_minPrice == null && _maxPrice == null) return null;
    
    for (int i = 0; i < priceRanges.length; i++) {
      final range = priceRanges[i];
      if (range['min'] == _minPrice && range['max'] == _maxPrice) {
        return '${range['min']}_${range['max']}_$i';
      }
    }
    return null;
  }

  void _onMinRoomsChanged(int? value) {
    setState(() {
      _minRooms = value;
      // Ensure min rooms doesn't exceed max rooms
      if (_maxRooms != null && value != null && value > _maxRooms!) {
        _maxRooms = value;
      }
    });
  }

  void _onMaxRoomsChanged(int? value) {
    setState(() {
      _maxRooms = value;
      // Ensure max rooms doesn't go below min rooms
      if (_minRooms != null && value != null && value < _minRooms!) {
        _minRooms = value;
      }
    });
  }

  List<Map<String, dynamic>> _buildPriceRangesFromAPI(FilterOptions filterOptions) {
    final priceList = filterOptions.priceList;
    if (priceList == null || priceList.isEmpty) {
      return [{'label': AppStrings.any_price.tr(), 'min': null, 'max': null}];
    }

    final ranges = <Map<String, dynamic>>[];
    final usedLabels = <String>{};
    
    // Add "Any Price" option
    ranges.add({'label': AppStrings.any_price.tr(), 'min': null, 'max': null});
    usedLabels.add(AppStrings.any_price.tr());
    
    // Create ranges based on API data
    for (int i = 0; i < priceList.length - 1; i++) {
      final min = priceList[i];
      final max = priceList[i + 1];
      String label = '${_formatPrice(min)} - ${_formatPrice(max)}';
      
      // Ensure unique labels by adding a counter if needed
      int counter = 1;
      String originalLabel = label;
      while (usedLabels.contains(label)) {
        label = '$originalLabel ($counter)';
        counter++;
      }
      
      ranges.add({
        'label': label,
        'min': min,
        'max': max,
      });
      usedLabels.add(label);
    }
    
    // Add "Above X" for the last price
    if (priceList.isNotEmpty) {
      final lastPrice = priceList.last;
      String label = 'Above ${_formatPrice(lastPrice)}';
      
      // Ensure unique labels by adding a counter if needed
      int counter = 1;
      String originalLabel = label;
      while (usedLabels.contains(label)) {
        label = '$originalLabel ($counter)';
        counter++;
      }
      
      ranges.add({
        'label': label,
        'min': lastPrice,
        'max': null,
      });
      usedLabels.add(label);
    }
    
    return ranges;
  }

  List<Map<String, dynamic>> _buildQuickRoomOptions() {
    final options = <Map<String, dynamic>>[];
    
    // Add "Any Rooms" option
    options.add({'label': AppStrings.any_rooms.tr(), 'min': null, 'max': null});
    
    // Generate quick options based on API range
    if (_maxRoomsFromAPI > _minRoomsFromAPI) {
      final range = _maxRoomsFromAPI - _minRoomsFromAPI;
      
      if (range <= 5) {
        // For small ranges, create individual options
        for (int i = _minRoomsFromAPI; i <= _maxRoomsFromAPI; i++) {
          options.add({'label': '$i', 'min': i, 'max': i});
        }
      } else {
        // For larger ranges, create grouped options
        final step = (range / 4).ceil();
        for (int i = _minRoomsFromAPI; i < _maxRoomsFromAPI; i += step) {
          final end = (i + step - 1).clamp(_minRoomsFromAPI, _maxRoomsFromAPI);
          if (i == end) {
            options.add({'label': '$i', 'min': i, 'max': i});
          } else {
            options.add({'label': '$i-$end', 'min': i, 'max': end});
          }
        }
        
        // Add the last range if needed
        final lastStart = ((_maxRoomsFromAPI - step + 1).clamp(_minRoomsFromAPI, _maxRoomsFromAPI));
        if (lastStart < _maxRoomsFromAPI) {
          options.add({'label': '${lastStart}+', 'min': lastStart, 'max': null});
        }
      }
    }
    
    return options;
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Center(
          child: Text(
            'Loading properties...',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return price.toString();
    }
  }

  String? _buildRoomsRangeText() {
    if (_minRooms == null && _maxRooms == null) {
      return null;
    }
    
    if (_minRooms == _maxRooms) {
      return '$_minRooms';
    }
    
    if (_minRooms == null) {
      return 'Up to $_maxRooms';
    }
    
    if (_maxRooms == null) {
      return '$_minRooms+';
    }
    
    return '$_minRooms - $_maxRooms';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
