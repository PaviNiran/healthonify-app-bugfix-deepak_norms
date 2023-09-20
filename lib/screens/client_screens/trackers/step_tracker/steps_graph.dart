import 'dart:developer';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/steps_tracker.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/drop_downs/filter_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StepsGraphCard extends StatefulWidget {
  const StepsGraphCard({Key? key}) : super(key: key);

  @override
  State<StepsGraphCard> createState() => _StepsGraphCardState();
}

class _StepsGraphCardState extends State<StepsGraphCard> {
  List<int> intList = List.generate(
    16,
    (int index) {
      return index = index * 1000;
    },
    growable: false,
  );

  double? graphScrollWidth;

  @override
  void initState() {
    super.initState();
    intList = intList.reversed.toList();

    setState(() {
      filterValue = filterOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (filterValue == filterOptions[0]) {
      graphScrollWidth = MediaQuery.of(context).size.width;
    } else if (filterValue == filterOptions[1]) {
      graphScrollWidth = MediaQuery.of(context).size.width * 3.8;
    } else if (filterValue == filterOptions[2]) {
      graphScrollWidth = MediaQuery.of(context).size.width * 7.45;
    } else if (filterValue == filterOptions[3]) {
      graphScrollWidth = MediaQuery.of(context).size.width * 11.1;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            FilterDropDown(
              onSelected: () {
                setState(() {});
              },
            ),
            Consumer<StepTrackerProvider>(
              builder: (context, stepsData, child) => stepsData
                      .stepsData.isEmpty
                  ? const Center(
                      child: Text("No Data Available"),
                    )
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          child: SizedBox(
                            height: 580,
                            width: graphScrollWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: BarChart(
                                BarChartData(
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(),
                                    rightTitles: AxisTitles(),
                                    topTitles: AxisTitles(),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        getTitlesWidget: getTitles,
                                        reservedSize: 30,
                                        showTitles: true,
                                      ),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    drawHorizontalLine: true,
                                  ),
                                  alignment: BarChartAlignment.center,
                                  maxY: 15000,
                                  groupsSpace: 30,
                                  barTouchData: BarTouchData(enabled: true),
                                  barGroups: stepsData.stepsData.map(
                                    (d) {
                                      log(d.date!);
                                      return BarChartGroupData(
                                        barsSpace: 20,
                                        x: int.parse(d.date!),
                                        barRods: [
                                          BarChartRodData(
                                            toY: d.stepsCount != null
                                                ? d.stepsCount!.toDouble()
                                                : 0,
                                            width: 20.0,
                                            color: orange,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: ColoredBox(
                            color: Theme.of(context).canvasColor,
                            child: SizedBox(
                              height: 1000,
                              width: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: intList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 7.5,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            '${intList[index]}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            textAlign: TextAlign.right,
                                            textScaleFactor: 1,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    int val = value.toInt();
    var dt = DateTime.fromMillisecondsSinceEpoch(val);
    String dss = DateFormat("E").format(dt);
    String v = DateFormat("dd MMM").format(dt);

    const style = TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 12,
    );
    Widget text;
    switch (dss) {
      case "Mon":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Tue":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Wed":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Thu":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Fri":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Sat":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Sun":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      default:
        text = const Text(
          '',
          style: style,
          textScaleFactor: 1,
        );
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
