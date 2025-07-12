import 'package:energy_web_app/controllers/dashboard_controller.dart';
import 'package:energy_web_app/models/data_point.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';


void main() {
  late DashboardController controller;
// DashboardController? controller;
  setUp(() {
    Get.testMode = true;
    controller = DashboardController();

    controller.allData.value = [
      DataPoint(
        stateId: 'CA',
        state: 'California',
        seriesId: 'SOTCB',
        energyType: 'Solar',
        year: 2023,
        value: 100.0,
      ),
      DataPoint(
        stateId: 'TX',
        state: 'Texas',
        seriesId: 'WETCB',
        energyType: 'Wind',
        year: 2022,
        value: 80.0,
      ),
      DataPoint(
        stateId: 'NY',
        state: 'New York',
        seriesId: 'COICB',
        energyType: 'Crude Oil',
        year: 2021,
        value: 50.0,
      ),
    ];
  });

  test('data is populated and filter by state works', () {
    controller.selectedState.value = 'TX';
    controller.applyFilters();

    expect(controller.filteredData.length, 1);
    expect(controller.filteredData.first.stateId, 'TX');
  });

  test('Filter by energy type', () {
    controller.selectedType.value = 'COICB';
    controller.applyFilters();

    expect(controller.filteredData.length, 1);
    expect(controller.filteredData.first.energyType, 'Crude Oil');
  });

  test('Filter by year', () {
    controller.searchYear.value = '2023';
    controller.applyFilters();

    expect(controller.filteredData.length, 1);
    expect(controller.filteredData.first.year, 2023);
  });

  test('Sorting by year descending works', () {
    controller.sortField.value = 'year';
    controller.sortAscending.value = false;
    controller.applyFilters();

    expect(controller.filteredData.first.year, 2023);
    expect(controller.filteredData.last.year, 2021);
  });

  test('Pagination shows correct number of items', () {
    controller.itemsPerPage = 2;
    controller.applyFilters();

    expect(controller.paginatedData.length, 2);
  });
}
