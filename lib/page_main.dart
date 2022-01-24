import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stockbit_bibit_test/api/api_notification.dart';
import 'package:stockbit_bibit_test/model/model_alarm.dart';
import 'package:stockbit_bibit_test/page_statistic.dart';
import 'package:stockbit_bibit_test/widgets/button_primary.dart';
import 'package:stockbit_bibit_test/widgets/clock.dart';

class PageMain extends StatefulWidget {
  const PageMain({Key? key}) : super(key: key);

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  int minuteClock = 0;
  int hourClock = 0;
  bool isAm = true;
  bool isSetHourActive = false;
  bool isSetMinuteActive = false;
  bool isSetAlarmDone = false;
  bool isSetAlarmStart = false;

  setMinHourClock() {
    var now = DateTime.now();
    setState(() {
      minuteClock = now.minute;
      if (now.hour >= 12) {
        isAm = false;
        hourClock = now.hour - 12;
      } else {
        hourClock = now.hour;
        isAm = true;
      }
    });
  }

  void addAlarm() {
    setState(() {
      alarmList.add(ModelAlarm(
        hour: hourClock,
        minute: minuteClock,
        isAm: isAm,
        isActive: true,
      ));
    });
  }

  void listenNotifications() {
    ApiNotification.onNotifications.stream.listen(onClickNotification);
  }

  void onClickNotification(String? payload) {
    var random = Random();
    openedAt.add(random.nextInt(30));
    Get.to(
      () => PageStatistic(payload: payload ?? ''),
      transition: Transition.downToUp,
    );
  }

  @override
  void initState() {
    setMinHourClock();
    ApiNotification.init(initScheduled: true);
    listenNotifications();
    super.initState();
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
                child: Clock(
                  minuteClock: minuteClock,
                  hourClock: hourClock,
                  isAm: isAm,
                  initialValue: (isSetHourActive == true)
                      ? 12
                      : (isSetMinuteActive == true)
                          ? 60
                          : 60,
                  max: (isSetHourActive == true)
                      ? 12
                      : (isSetMinuteActive == true)
                          ? 60
                          : 60,
                  onChange: (value) {
                    if (isSetHourActive == true) {
                      setState(() {
                        hourClock = value.toInt();
                      });
                    } else if (isSetMinuteActive == true) {
                      setState(() {
                        minuteClock = value.toInt();
                      });
                    }
                  },
                ),
              ),
            ),
            alarmList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                    itemCount: alarmList.length,
                    itemBuilder: (context, index) {
                      return alarmList.isNotEmpty
                          ? Container(
                              width: Get.width,
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: const Color(0xFF444974),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            alarmList.removeAt(index);
                                          });
                                        },
                                        icon: Icon(Icons.delete,
                                            color: const Color(0xFFEAECFF),
                                            size: 30.w)),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFFEAECFF),
                                        ),
                                        padding: EdgeInsets.all(10.w),
                                        child: Text(
                                            alarmList[index]
                                                .hour
                                                .toString()
                                                .padLeft(2, '0'),
                                            style: TextStyle(
                                                fontSize: 16.w,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    const Color(0xFF444974))),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10.w),
                                        child: Text(':',
                                            style: TextStyle(
                                                fontSize: 16.w,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    const Color(0xFFEAECFF))),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFFEAECFF),
                                        ),
                                        padding: EdgeInsets.all(10.w),
                                        child: Text(
                                            alarmList[index]
                                                .minute
                                                .toString()
                                                .padLeft(2, '0'),
                                            style: TextStyle(
                                                fontSize: 16.w,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    const Color(0xFF444974))),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    child: Column(
                                      children: [
                                        Text('AM',
                                            style: TextStyle(
                                                fontSize: 16.w,
                                                fontWeight: FontWeight.w500,
                                                color: (alarmList[index].isAm ==
                                                        true)
                                                    ? const Color(0xFFEAECFF)
                                                    : Colors.grey)),
                                        Text('PM',
                                            style: TextStyle(
                                                fontSize: 16.w,
                                                fontWeight: FontWeight.w500,
                                                color: (alarmList[index].isAm !=
                                                        true)
                                                    ? const Color(0xFFEAECFF)
                                                    : Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container();
                    },
                  ))
                : Container(),
            isSetAlarmStart == true
                ? Container(
                    width: Get.width,
                    margin: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: ButtonPrimary(
                                  onPressed: () {
                                    setState(() {
                                      isSetHourActive = !isSetHourActive;
                                      isSetMinuteActive = false;
                                    });
                                  },
                                  title: hourClock.toString().padLeft(2, '0'),
                                  backgroundColor: (isSetAlarmDone == true)
                                      ? const Color(0xFF444974)
                                      : const Color(0xFFEAECFF),
                                  titleStyle: (isSetAlarmDone == true)
                                      ? TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFEAECFF))
                                      : TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.w500,
                                          color: (isSetHourActive != true)
                                              ? Colors.grey
                                              : const Color(0xFFEA74AB)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 20.w,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFEAECFF)),
                                ),
                              ),
                              Expanded(
                                child: ButtonPrimary(
                                  onPressed: () {
                                    setState(() {
                                      isSetMinuteActive = !isSetMinuteActive;
                                      isSetHourActive = false;
                                    });
                                  },
                                  title: minuteClock.toString().padLeft(2, '0'),
                                  backgroundColor: (isSetAlarmDone == true)
                                      ? const Color(0xFF444974)
                                      : const Color(0xFFEAECFF),
                                  titleStyle: (isSetAlarmDone == true)
                                      ? TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFEAECFF))
                                      : TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.w500,
                                          color: (isSetMinuteActive != true)
                                              ? Colors.grey
                                              : const Color(0xFF748EF6)),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20.w),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 70.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: ButtonPrimary(
                                  onPressed: () {
                                    setState(() {
                                      isAm = !isAm;
                                    });
                                  },
                                  title: 'AM',
                                  backgroundColor: (isAm == true)
                                      ? const Color(0xFF444974)
                                      : const Color(0xFFEAECFF),
                                  titleStyle: TextStyle(
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.w500,
                                      color: (isAm == true)
                                          ? const Color(0xFFEAECFF)
                                          : Colors.grey),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: ButtonPrimary(
                                  onPressed: () {
                                    setState(() {
                                      isAm = !isAm;
                                    });
                                  },
                                  title: 'PM',
                                  backgroundColor: (isAm != true)
                                      ? const Color(0xFF444974)
                                      : const Color(0xFFEAECFF),
                                  titleStyle: TextStyle(
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.w500,
                                      color: (isAm != true)
                                          ? const Color(0xFFEAECFF)
                                          : Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            (isSetAlarmStart == true)
                ? ButtonPrimary(
                    onPressed: () {
                      setState(() {
                        isSetAlarmDone = true;
                        isSetHourActive = false;
                        isSetMinuteActive = false;
                        isSetAlarmStart = false;
                        addAlarm();
                        addLabelChartBottom(date: DateTime.now());
                        ApiNotification().showScheduleNotification(
                          title: 'Alarm',
                          body: 'Wake Up !!',
                          payload: minuteClock.toString(),
                        );
                      });
                    },
                    backgroundColor: const Color(0xFF444974),
                    margin:
                        EdgeInsets.symmetric(vertical: 30.w, horizontal: 20.w),
                    title: 'Save',
                    titleStyle: TextStyle(
                        fontSize: 16.w, color: const Color(0xFFEAECFF)),
                  )
                : ButtonPrimary(
                    onPressed: () {
                      setMinHourClock();
                      setState(() {
                        isSetAlarmStart = true;
                        isSetAlarmDone = false;
                        if (alarmList.isNotEmpty) alarmList.removeAt(0);
                      });
                    },
                    backgroundColor: const Color(0xFF444974),
                    margin:
                        EdgeInsets.symmetric(vertical: 30.w, horizontal: 20.w),
                    title: 'Set Alarm Now',
                    titleStyle: TextStyle(
                        fontSize: 16.w, color: const Color(0xFFEAECFF)),
                  )
          ],
        ),
      )),
    );
  }
}
