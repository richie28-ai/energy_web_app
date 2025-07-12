// controllers/solar_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/data_point.dart';
import '../services/api_service.dart';


class DashboardController extends GetxController {
  var allData = <DataPoint>[].obs;
  var filteredData = <DataPoint>[].obs;
  var isLoading = false.obs;

  var selectedState = ''.obs;
  var selectedType = ''.obs;
  var searchYear = ''.obs;
  var sortAscending = true.obs;
  var sortField = 'year'.obs;

  int itemsPerPage = 10;
  var currentPage = 0.obs;
  var hasNoFilteredResults = false.obs;

  // Admin role check
  var isAdmin = false.obs;

  final Map<String, String> availableStates = {
    'CA': 'California',
    'TX': 'Texas',
    'NY': 'New York'
  };

  final Map<String, String> availableTypes = {
    'SOTCB': 'Solar',
    'WETCB': 'Wind',
    'COICB': 'Crude Oil',
    'CLEIV': 'Coal'
  };

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    fetchSolarData();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent &&
          !isLoading.value) {
        nextPage();
      }
    });


    final args = Get.arguments;
    if (args != null && args['role'] == 'admin') {
      isAdmin.value = true;
    }

    super.onInit();
  }

  void fetchSolarData() async {
    try {
      isLoading.value = true;
      allData.value = await ApiService.fetchSolarData(
        states: availableStates.keys.toList(),
        seriesIds: availableTypes.keys.toList(),
      );
      applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Could not load solar data');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<DataPoint> data = List.from(allData);

    if (searchYear.isNotEmpty) {
      data = data.where((e) => e.year.toString().contains(searchYear.value)).toList();
    }
    if (selectedState.isNotEmpty) {
      data = data.where((e) => e.stateId == selectedState.value).toList();
    }
    if (selectedType.isNotEmpty) {
      data = data.where((e) => e.seriesId == selectedType.value).toList();
    }

    data.sort((a, b) {
      int compare;
      switch (sortField.value) {
        case 'state':
          compare = a.state.compareTo(b.state);
          break;
        case 'energyType':
          compare = a.energyType.compareTo(b.energyType);
          break;
        case 'year':
        default:
          compare = a.year.compareTo(b.year);
      }
      return sortAscending.value ? compare : -compare;
    });

    filteredData.value = data;
    hasNoFilteredResults.value = data.isEmpty;
    currentPage.value = 0;
  }

  List<DataPoint> get paginatedData {
    final start = currentPage.value * itemsPerPage;
    return filteredData.skip(start).take(itemsPerPage).toList();
  }

  void nextPage() {
    if ((currentPage.value + 1) * itemsPerPage < filteredData.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }
}
