import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stockbit_bibit_test/model/model_alarm.dart';
import 'package:stockbit_bibit_test/widgets/button_primary.dart';

class PageStatistic extends StatefulWidget {
  final String payload;

  const PageStatistic({
    required this.payload,
    Key? key,
  }) : super(key: key);

  @override
  State<PageStatistic> createState() => _PageStatisticState();
}

class _PageStatisticState extends State<PageStatistic> {
  List<Color> colour = [
    const Color(0xffffaf1a),
    const Color(0xfff66500),
  ];
  List<FlSpot> spot() {
    return List<FlSpot>.generate(openedAt.length,
        (index) => FlSpot(index.toDouble(), openedAt[index].toDouble()));
  }

  List<BarChartGroupData> data() {
    return List<BarChartGroupData>.generate(
      openedAt.length,
      (index) => BarChartGroupData(
        x: index,
        barsSpace: 30,
        barRods: [
          BarChartRodData(
              borderRadius: BorderRadius.circular(0),
              y: openedAt[index].toDouble(),
              width: 15,
              colors: [Colors.amber]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2F41),
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: const Color(0xFF2D2F41),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 70.w, right: 20.w, bottom: 20.w, left: 10.w),
                  child: BarChart(
                    BarChartData(
                      backgroundColor: const Color(0xFF0D162D),
                      minY: 0,
                      maxY: openedAt
                          .reduce((curr, next) => curr > next ? curr : next)
                          .toDouble(),
                      borderData: FlBorderData(
                          border: const Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                        left: BorderSide(width: 1),
                        bottom: BorderSide(width: 1),
                      )),
                      // groupsSpace: 30,
                      barGroups: data(),
                      titlesData: FlTitlesData(
                        rightTitles: SideTitles(showTitles: false),
                        topTitles: SideTitles(showTitles: false),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (context, v) {
                            return TextStyle(
                              color: Colors.white,
                              fontSize: 12.w,
                            );
                          },
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            for (int i = 0; i < labelChartBottom.length; i++) {
                              if (value.toInt() == i) {
                                return labelChartBottom[i];
                              }
                            }
                            return '';
                          },
                          getTextStyles: (context, v) {
                            return TextStyle(
                                color: Colors.white, fontSize: 12.w);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ButtonPrimary(
                backgroundColor: const Color(0xFF444974),
                margin: EdgeInsets.symmetric(vertical: 30.w, horizontal: 20.w),
                onPressed: () {
                  Get.back();
                },
                title: 'BACK',
              )
            ],
          ),
        ),
      ),
    );
  }
}
