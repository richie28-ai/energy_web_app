import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/data_point.dart';
import '../../controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Obx((){
                return controller.isAdmin.value ?   Text('Admin', style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold)) :  Text('User', style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold));
              }),
               SizedBox(height: 10.0),
              Row(children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('State'),
                    value: controller.selectedState.value.isEmpty
                        ? null
                        : controller.selectedState.value,
                    onChanged: (val) {
                      controller.selectedState.value = val ?? '';
                      controller.applyFilters();
                    },
                    items: controller.availableStates.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('Energy Type'),
                    value: controller.selectedType.value.isEmpty
                        ? null
                        : controller.selectedType.value,
                    onChanged: (val) {
                      controller.selectedType.value = val ?? '';
                      controller.applyFilters();
                    },
                    items: controller.availableTypes.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                        .toList(),
                  ),
                ),
              ]),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        controller.searchYear.value = val;
                        controller.applyFilters();
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Search by year'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(controller.sortAscending.value
                        ? Icons.arrow_upward
                        : Icons.arrow_downward),
                    onPressed: () {
                      controller.sortAscending.toggle();
                      controller.applyFilters();
                    },
                  ),
                  DropdownButton<String>(
                    value: controller.sortField.value,
                    items: const [
                      DropdownMenuItem(value: 'year', child: Text('Year')),
                      DropdownMenuItem(value: 'state', child: Text('State')),
                      DropdownMenuItem(value: 'energyType', child: Text('Type')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.sortField.value = value;
                        controller.applyFilters();
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  final dataList = controller.paginatedData;

                  if (controller.hasNoFilteredResults.value) {
                    return const Center(
                      child: Text(
                        'No data found for the selected filters.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];
                      return Card(
                        child: ListTile(
                          title: Text('${data.energyType} | ${data.state}'),
                          subtitle: Text('Year: ${data.year}'),
                          trailing: Text('${data.value} B Btu'),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: controller.previousPage,
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: controller.nextPage,
                    child: const Text('Next'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text('Consumption Trend'),
              SizedBox(
                height: 200,
                child: Obx(() {
                  return LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: controller.filteredData
                              .map((e) => FlSpot(e.year.toDouble(), e.value))
                              .toList(),
                          isCurved: true,
                        ),
                      ],
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                    ),
                  );
                }),
              )
            ],
          ),
        );
      }),
    );
  }
}
