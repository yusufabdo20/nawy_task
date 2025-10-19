import 'package:dio/dio.dart';
import 'package:nawy_task/core/errors/exceptions.dart';
import 'package:nawy_task/core/network/api_constants.dart';
import 'package:nawy_task/core/network/api_services.dart';
import 'package:nawy_task/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:nawy_task/features/explore/data/models/areas_response_model/areas_response_model.dart';
import 'package:nawy_task/features/explore/data/models/compounds_response_model/compounds_response_model.dart';
import 'package:nawy_task/features/explore/data/models/properties_search_responnse_model/properties_search_responnse_model.dart';
import 'package:nawy_task/features/explore/data/models/properties_get_filtration_options_response_model/properties_get_filtration_options_response_model.dart';
import 'package:nawy_task/features/explore/domain/entities/area.dart';
import 'package:nawy_task/features/explore/domain/entities/compound.dart';
import 'package:nawy_task/features/explore/domain/entities/property.dart';
import 'package:nawy_task/features/explore/domain/entities/filter_options.dart';

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final ApiService _apiService;

  ExploreRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<Compound>> getCompounds() async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.apiBaseUrl}${ApiConstants.compoundsEndPoint}',
      );

      if (response is List) {
        return response
            .map((json) => CompoundsResponseModel.fromJson(json))
            .map((model) => Compound(
                  id: model.id,
                  areaId: model.areaId,
                  developerId: model.developerId,
                  name: model.name,
                  slug: model.slug,
                  updatedAt: model.updatedAt,
                  imagePath: model.imagePath,
                  nawyOrganizationId: model.nawyOrganizationId,
                  hasOffers: model.hasOffers,
                  areaName: model.area?.name,
                ))
            .toList();
      }
      throw const ServerException(message: 'Invalid response format');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<Area>> getAreas() async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.apiBaseUrl}${ApiConstants.AreasEndPoint}',
      );

      if (response is List) {
        return response
            .map((json) => AreasResponseModel.fromJson(json))
            .map((model) => Area(
                  id: model.id,
                  name: model.name,
                  slug: model.slug,
                ))
            .toList();
      }
      throw const ServerException(message: 'Invalid response format');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<Property>> searchProperties({
    String? areaName,
    String? compoundName,
    String? developerName,
    int? minPrice,
    int? maxPrice,
    int? minBedrooms,
    int? maxBedrooms,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.apiBaseUrl}${ApiConstants.propertiesSearchEndPoint}',
      );

      if (response is Map<String, dynamic>) {
        final searchResponse = PropertiesSearchResponnseModel.fromJson(response);
        final values = searchResponse.values ?? [];
        
        List<Property> properties = values
            .map((value) => Property(
                  id: value.id?.toInt(),
                  name: value.name,
                  slug: value.slug,
                  propertyType: 'Property Type ${value.propertyType?.id ?? 'Unknown'}',
                  deliveryYear: value.minReadyBy,
                  price: value.minPrice?.toDouble(),
                  monthlyPayment: value.minInstallments?.toDouble(),
                  paymentYears: value.maxInstallmentYears?.toInt(),
                  compound: value.compound?.name,
                  location: value.area?.name,
                  bedrooms: value.numberOfBedrooms?.toInt(),
                  bathrooms: value.numberOfBathrooms?.toInt(),
                  area: value.minUnitArea?.toString(),
                  imageUrl: value.image,
                  developerName: value.developer?.name,
                  developerLogo: value.developer?.logoPath,
                ))
            .toList();

        // Apply text-based filters
        if ((areaName != null && areaName.isNotEmpty) || 
            (compoundName != null && compoundName.isNotEmpty) || 
            (developerName != null && developerName.isNotEmpty)) {
          
          final searchQuery = areaName ?? compoundName ?? developerName ?? '';
          final lowerQuery = searchQuery.toLowerCase();
          
          properties = properties
              .where((property) =>
                  (property.location?.toLowerCase().contains(lowerQuery) == true) ||
                  (property.compound?.toLowerCase().contains(lowerQuery) == true) ||
                  (property.developerName?.toLowerCase().contains(lowerQuery) == true))
              .toList();
        }

        // Apply price filters
        if (minPrice != null || maxPrice != null) {
          properties = properties.where((property) {
            final price = property.price ?? 0;
            final passesMin = minPrice == null || price >= minPrice;
            final passesMax = maxPrice == null || price <= maxPrice;
            return passesMin && passesMax;
          }).toList();
        }

        // Apply bedrooms filters
        if (minBedrooms != null || maxBedrooms != null) {
          print('Applying bedrooms filter: min=$minBedrooms, max=$maxBedrooms');
          final beforeCount = properties.length;
          properties = properties.where((property) {
            final bedrooms = property.bedrooms ?? 0;
            final passesMin = minBedrooms == null || bedrooms >= minBedrooms;
            final passesMax = maxBedrooms == null || bedrooms <= maxBedrooms;
            final passes = passesMin && passesMax;
            
            if (!passes) {
              print('Property ${property.name} filtered out: bedrooms=$bedrooms, min=$minBedrooms, max=$maxBedrooms');
            }
            
            return passes;
          }).toList();
          print('After bedrooms filtering: ${properties.length} properties (removed ${beforeCount - properties.length})');
        }

        print('Final result: ${properties.length} properties');
        return properties;
      }
      throw const ServerException(message: 'Invalid response format');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<FilterOptions> getFilterOptions() async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.apiBaseUrl}${ApiConstants.propertiesGetFiltrationOptionsEndPoint}',
      );

      if (response is Map<String, dynamic>) {
        final filterResponse = PropertiesGetFiltrationOptionsResponseModel.fromJson(response);
        
        return FilterOptions(
          minPrice: filterResponse.minPrice,
          maxPrice: filterResponse.maxPrice,
          priceList: filterResponse.priceList,
          minPriceList: filterResponse.minPriceList,
          maxPriceList: filterResponse.maxPriceList,
          minBedrooms: filterResponse.minBedrooms,
          maxBedrooms: filterResponse.maxBedrooms,
          minBathrooms: filterResponse.minBathrooms,
          maxBathrooms: filterResponse.maxBathrooms,
          minUnitArea: filterResponse.minUnitArea,
          maxUnitArea: filterResponse.maxUnitArea,
          propertyTypes: filterResponse.propertyTypes?.map((e) => e.name ?? '').toList(),
          finishings: filterResponse.finishings,
        );
      }
      throw const ServerException(message: 'Invalid response format');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
