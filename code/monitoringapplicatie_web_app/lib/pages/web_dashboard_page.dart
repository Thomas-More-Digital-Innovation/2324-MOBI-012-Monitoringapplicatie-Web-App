import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class WebPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RevAPP WEB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(15),
              child: Nav()),
              Column(
                children: [
                  const Text('Statistieken Patient X', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 60,),
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Row(
                        children: [
                          // Hoek over tijd
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('max hoek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                Container(
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  child: StreamBuilder(
                                    stream:
                                        FirebaseFirestore.instance.collection('DummyData').snapshots(),
                                    builder: (
                                      BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot,
                                    ) {
                                      if (!snapshot.hasData) return const SizedBox.shrink();

                                      // Extract data for the chart
                                      List<ChartData> chartDataList = snapshot.data!.docs.map((doc) {
                                        final int value = doc['X'] as int;
                                        final Timestamp timestamp = doc['date'] as Timestamp;
                                        final DateTime date = timestamp.toDate();
                                        return ChartData(value, date);
                                      }).toList();

                                      // Use a set to keep track of unique dates
                                      Set<DateTime> uniqueDates = Set<DateTime>();

                                      // Aggregate data by day and collect unique dates
                                      Map<DateTime, int> aggregatedData = {};
                                      for (ChartData data in chartDataList) {
                                        DateTime day =
                                            DateTime(data.date.year, data.date.month, data.date.day);
                                        if (!aggregatedData.containsKey(day)) {
                                          aggregatedData[day] = data.value;
                                          uniqueDates.add(day);
                                        } else {
                                          aggregatedData[day] = aggregatedData[day]! + data.value;
                                        }
                                      }

                                      // Convert aggregated data to a list
                                      List<ChartData> aggregatedChartDataList = uniqueDates
                                          .map((date) => ChartData(aggregatedData[date]!, date))
                                          .toList();

                                      // Sort the aggregated data by date
                                      aggregatedChartDataList.sort((a, b) => a.date.compareTo(b.date));

                                      return Column(
                                        children: [
                                          // Line Chart
                                          Expanded(
                                            child: SfCartesianChart(
                                              primaryXAxis: DateTimeAxis(
                                                dateFormat:
                                                    DateFormat('dd MMM'), // Display only day and month
                                                interval: 1, // Display every day
                                              ),
                                              series: <LineSeries<ChartData, DateTime>>[
                                                LineSeries<ChartData, DateTime>(
                                                  dataSource: aggregatedChartDataList,
                                                  xValueMapper: (ChartData data, _) => data.date,
                                                  yValueMapper: (ChartData data, _) => data.value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // List View
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final docData = snapshot.data?.docs[index];
                                                final int value = (docData!['X'] as int);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Hoek over tijd
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('max hoek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                Container(
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  child: StreamBuilder(
                                    stream:
                                    FirebaseFirestore.instance.collection('DummyData').snapshots(),
                                    builder: (
                                        BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot,
                                        ) {
                                      if (!snapshot.hasData) return const SizedBox.shrink();

                                      // Extract data for the chart
                                      List<ChartData> chartDataList = snapshot.data!.docs.map((doc) {
                                        final int value = doc['X'] as int;
                                        final Timestamp timestamp = doc['date'] as Timestamp;
                                        final DateTime date = timestamp.toDate();
                                        return ChartData(value, date);
                                      }).toList();

                                      // Use a set to keep track of unique dates
                                      Set<DateTime> uniqueDates = Set<DateTime>();

                                      // Aggregate data by day and collect unique dates
                                      Map<DateTime, int> aggregatedData = {};
                                      for (ChartData data in chartDataList) {
                                        DateTime day =
                                        DateTime(data.date.year, data.date.month, data.date.day);
                                        if (!aggregatedData.containsKey(day)) {
                                          aggregatedData[day] = data.value;
                                          uniqueDates.add(day);
                                        } else {
                                          aggregatedData[day] = aggregatedData[day]! + data.value;
                                        }
                                      }

                                      // Convert aggregated data to a list
                                      List<ChartData> aggregatedChartDataList = uniqueDates
                                          .map((date) => ChartData(aggregatedData[date]!, date))
                                          .toList();

                                      // Sort the aggregated data by date
                                      aggregatedChartDataList.sort((a, b) => a.date.compareTo(b.date));

                                      return Column(
                                        children: [
                                          // Line Chart
                                          Expanded(
                                            child: SfCartesianChart(
                                              primaryXAxis: DateTimeAxis(
                                                dateFormat:
                                                DateFormat('dd MMM'), // Display only day and month
                                                interval: 1, // Display every day
                                              ),
                                              series: <LineSeries<ChartData, DateTime>>[
                                                LineSeries<ChartData, DateTime>(
                                                  dataSource: aggregatedChartDataList,
                                                  xValueMapper: (ChartData data, _) => data.date,
                                                  yValueMapper: (ChartData data, _) => data.value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // List View
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final docData = snapshot.data?.docs[index];
                                                final int value = (docData!['X'] as int);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Hoek over tijd
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('max hoek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                Container(
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  child: StreamBuilder(
                                    stream:
                                    FirebaseFirestore.instance.collection('DummyData').snapshots(),
                                    builder: (
                                        BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot,
                                        ) {
                                      if (!snapshot.hasData) return const SizedBox.shrink();

                                      // Extract data for the chart
                                      List<ChartData> chartDataList = snapshot.data!.docs.map((doc) {
                                        final int value = doc['X'] as int;
                                        final Timestamp timestamp = doc['date'] as Timestamp;
                                        final DateTime date = timestamp.toDate();
                                        return ChartData(value, date);
                                      }).toList();

                                      // Use a set to keep track of unique dates
                                      Set<DateTime> uniqueDates = Set<DateTime>();

                                      // Aggregate data by day and collect unique dates
                                      Map<DateTime, int> aggregatedData = {};
                                      for (ChartData data in chartDataList) {
                                        DateTime day =
                                        DateTime(data.date.year, data.date.month, data.date.day);
                                        if (!aggregatedData.containsKey(day)) {
                                          aggregatedData[day] = data.value;
                                          uniqueDates.add(day);
                                        } else {
                                          aggregatedData[day] = aggregatedData[day]! + data.value;
                                        }
                                      }

                                      // Convert aggregated data to a list
                                      List<ChartData> aggregatedChartDataList = uniqueDates
                                          .map((date) => ChartData(aggregatedData[date]!, date))
                                          .toList();

                                      // Sort the aggregated data by date
                                      aggregatedChartDataList.sort((a, b) => a.date.compareTo(b.date));

                                      return Column(
                                        children: [
                                          // Line Chart
                                          Expanded(
                                            child: SfCartesianChart(
                                              primaryXAxis: DateTimeAxis(
                                                dateFormat:
                                                DateFormat('dd MMM'), // Display only day and month
                                                interval: 1, // Display every day
                                              ),
                                              series: <LineSeries<ChartData, DateTime>>[
                                                LineSeries<ChartData, DateTime>(
                                                  dataSource: aggregatedChartDataList,
                                                  xValueMapper: (ChartData data, _) => data.date,
                                                  yValueMapper: (ChartData data, _) => data.value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // List View
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final docData = snapshot.data?.docs[index];
                                                final int value = (docData!['X'] as int);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Row(
                        children: [
                          // Hoek over tijd
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('max hoek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                Container(
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  child: StreamBuilder(
                                    stream:
                                    FirebaseFirestore.instance.collection('DummyData').snapshots(),
                                    builder: (
                                        BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot,
                                        ) {
                                      if (!snapshot.hasData) return const SizedBox.shrink();

                                      // Extract data for the chart
                                      List<ChartData> chartDataList = snapshot.data!.docs.map((doc) {
                                        final int value = doc['X'] as int;
                                        final Timestamp timestamp = doc['date'] as Timestamp;
                                        final DateTime date = timestamp.toDate();
                                        return ChartData(value, date);
                                      }).toList();

                                      // Use a set to keep track of unique dates
                                      Set<DateTime> uniqueDates = Set<DateTime>();

                                      // Aggregate data by day and collect unique dates
                                      Map<DateTime, int> aggregatedData = {};
                                      for (ChartData data in chartDataList) {
                                        DateTime day =
                                        DateTime(data.date.year, data.date.month, data.date.day);
                                        if (!aggregatedData.containsKey(day)) {
                                          aggregatedData[day] = data.value;
                                          uniqueDates.add(day);
                                        } else {
                                          aggregatedData[day] = aggregatedData[day]! + data.value;
                                        }
                                      }

                                      // Convert aggregated data to a list
                                      List<ChartData> aggregatedChartDataList = uniqueDates
                                          .map((date) => ChartData(aggregatedData[date]!, date))
                                          .toList();

                                      // Sort the aggregated data by date
                                      aggregatedChartDataList.sort((a, b) => a.date.compareTo(b.date));

                                      return Column(
                                        children: [
                                          // Line Chart
                                          Expanded(
                                            child: SfCartesianChart(
                                              primaryXAxis: DateTimeAxis(
                                                dateFormat:
                                                DateFormat('dd MMM'), // Display only day and month
                                                interval: 1, // Display every day
                                              ),
                                              series: <LineSeries<ChartData, DateTime>>[
                                                LineSeries<ChartData, DateTime>(
                                                  dataSource: aggregatedChartDataList,
                                                  xValueMapper: (ChartData data, _) => data.date,
                                                  yValueMapper: (ChartData data, _) => data.value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // List View
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final docData = snapshot.data?.docs[index];
                                                final int value = (docData!['X'] as int);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Hoek over tijd
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('max hoek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                Container(
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  child: StreamBuilder(
                                    stream:
                                    FirebaseFirestore.instance.collection('DummyData').snapshots(),
                                    builder: (
                                        BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot,
                                        ) {
                                      if (!snapshot.hasData) return const SizedBox.shrink();

                                      // Extract data for the chart
                                      List<ChartData> chartDataList = snapshot.data!.docs.map((doc) {
                                        final int value = doc['X'] as int;
                                        final Timestamp timestamp = doc['date'] as Timestamp;
                                        final DateTime date = timestamp.toDate();
                                        return ChartData(value, date);
                                      }).toList();

                                      // Use a set to keep track of unique dates
                                      Set<DateTime> uniqueDates = Set<DateTime>();

                                      // Aggregate data by day and collect unique dates
                                      Map<DateTime, int> aggregatedData = {};
                                      for (ChartData data in chartDataList) {
                                        DateTime day =
                                        DateTime(data.date.year, data.date.month, data.date.day);
                                        if (!aggregatedData.containsKey(day)) {
                                          aggregatedData[day] = data.value;
                                          uniqueDates.add(day);
                                        } else {
                                          aggregatedData[day] = aggregatedData[day]! + data.value;
                                        }
                                      }

                                      // Convert aggregated data to a list
                                      List<ChartData> aggregatedChartDataList = uniqueDates
                                          .map((date) => ChartData(aggregatedData[date]!, date))
                                          .toList();

                                      // Sort the aggregated data by date
                                      aggregatedChartDataList.sort((a, b) => a.date.compareTo(b.date));

                                      return Column(
                                        children: [
                                          // Line Chart
                                          Expanded(
                                            child: SfCartesianChart(
                                              primaryXAxis: DateTimeAxis(
                                                dateFormat:
                                                DateFormat('dd MMM'), // Display only day and month
                                                interval: 1, // Display every day
                                              ),
                                              series: <LineSeries<ChartData, DateTime>>[
                                                LineSeries<ChartData, DateTime>(
                                                  dataSource: aggregatedChartDataList,
                                                  xValueMapper: (ChartData data, _) => data.date,
                                                  yValueMapper: (ChartData data, _) => data.value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // List View
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final docData = snapshot.data?.docs[index];
                                                final int value = (docData!['X'] as int);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Hoek over tijd
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('max hoek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                Container(
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  child: StreamBuilder(
                                    stream:
                                    FirebaseFirestore.instance.collection('DummyData').snapshots(),
                                    builder: (
                                        BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot,
                                        ) {
                                      if (!snapshot.hasData) return const SizedBox.shrink();

                                      // Extract data for the chart
                                      List<ChartData> chartDataList = snapshot.data!.docs.map((doc) {
                                        final int value = doc['X'] as int;
                                        final Timestamp timestamp = doc['date'] as Timestamp;
                                        final DateTime date = timestamp.toDate();
                                        return ChartData(value, date);
                                      }).toList();

                                      // Use a set to keep track of unique dates
                                      Set<DateTime> uniqueDates = Set<DateTime>();

                                      // Aggregate data by day and collect unique dates
                                      Map<DateTime, int> aggregatedData = {};
                                      for (ChartData data in chartDataList) {
                                        DateTime day =
                                        DateTime(data.date.year, data.date.month, data.date.day);
                                        if (!aggregatedData.containsKey(day)) {
                                          aggregatedData[day] = data.value;
                                          uniqueDates.add(day);
                                        } else {
                                          aggregatedData[day] = aggregatedData[day]! + data.value;
                                        }
                                      }

                                      // Convert aggregated data to a list
                                      List<ChartData> aggregatedChartDataList = uniqueDates
                                          .map((date) => ChartData(aggregatedData[date]!, date))
                                          .toList();

                                      // Sort the aggregated data by date
                                      aggregatedChartDataList.sort((a, b) => a.date.compareTo(b.date));

                                      return Column(
                                        children: [
                                          // Line Chart
                                          Expanded(
                                            child: SfCartesianChart(
                                              primaryXAxis: DateTimeAxis(
                                                dateFormat:
                                                DateFormat('dd MMM'), // Display only day and month
                                                interval: 1, // Display every day
                                              ),
                                              series: <LineSeries<ChartData, DateTime>>[
                                                LineSeries<ChartData, DateTime>(
                                                  dataSource: aggregatedChartDataList,
                                                  xValueMapper: (ChartData data, _) => data.date,
                                                  yValueMapper: (ChartData data, _) => data.value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // List View
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final docData = snapshot.data?.docs[index];
                                                final int value = (docData!['X'] as int);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final int value;
  final DateTime date;

  ChartData(this.value, this.date);
}
