import 'package:myputt/cubits/home/data/enums.dart';
import 'package:myputt/models/data/conditions/conditions.dart';

class HomeChartFilters {
  HomeChartFilters({
    required this.puttingActivityTypes,
    required this.puttingConditions,
  });
  final List<PuttingActivityType> puttingActivityTypes;
  final PuttingConditions? puttingConditions;
}
