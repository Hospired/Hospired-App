import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../backend-api/api_service.dart';
import '../backend-api/dtos.dart';

final healthcareFacilitiesProvider =
    FutureProvider<List<HealthcareFacilityRes>>((ref) async {
      return await ApiService.getHealthcareFacilities();
    });
