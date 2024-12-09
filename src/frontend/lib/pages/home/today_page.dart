import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:lottie/lottie.dart';

import '../../provider/time_provider.dart';
import '../../services/django/api_service.dart';
import '../../util/task_cards.dart';
import './calender_page.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<dynamic> meeting = [];
  final ApiService apiService = ApiService();
  @override
  void initState() {
    // TODO: TASK 3: implement initState
    super.initState();
    final timeProvider = Provider.of<TimeProvider>(context, listen: false);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timeProvider.setTime();
    });
    fetchCalendar();
  }

  Future<void> fetchCalendar() async {
    final response = await ApiService().getTodayCalendar();
    if (response != null) {   // TODO TASK 3: The operand can't be null, so the condition is always true
      setState(() {
        meeting = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
      maxHeight: 800,
      defaultPanelState: PanelState.CLOSED,
      isDraggable: true,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      panel: Padding(
        padding: const EdgeInsets.only(top: 32, left: 5, right: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Activities",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: 45,
                    width: 110,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(22)),
                    child: Center(
                      child: Text(
                        "Reminders",
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    children: meeting.isNotEmpty
                        ? meeting.map((task) {
                            DateTime start = DateTime.parse(task['start_date']);
                            DateTime end = DateTime.parse(task['end_date']);
                            Duration duration = end.difference(start);
                            DateTime current = DateTime.now().toLocal();
                            int diff = start.day - current.day;
                            String date = diff == 0
                                ? 'Today'
                                : diff == 1
                                    ? 'Tomorrow'
                                    : DateFormat('EEEE').format(start);
                            return TaskCard(
                                date: date,
                                clr: Color(int.parse('0x${task['color']}')),
                                title: task['title'], // Pass title
                                start: DateFormat('h:mm a').format(start),
                                end: DateFormat('h:mm a').format(end),
                                duration:
                                    '${duration.inHours} hours', // Pass duration
                                description: task['description'],
                                source: 'From ' + task['calendar']['name']);
                          }).toList()
                        : [
                            Center(
                              child: Text(
                                'No upcoming events',
                                style: GoogleFonts.getFont('Nunito',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Let\'s add some events',
                              style: GoogleFonts.getFont('Nunito',
                                  fontSize: 20, color: Colors.black),
                            ),
                            Lottie.asset(
                              'assets/animations/bus.json',
                              width: MediaQuery.of(context).size.height * 1,
                              height: MediaQuery.of(context).size.height * 0.4,
                              repeat: true,
                              fit: BoxFit.fill,
                            )
                          ]),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth * 0.9,
          // rgba(153,154,157,255)
          color: const Color.fromARGB(255, 186, 187, 190),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 147, 139, 174),
                                borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  "Today",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          CalenderPage()))).then((value) {
                                fetchCalendar();
                              })),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  "Calendar",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  DateFormat('EEEE').format(DateTime.now()),
                  style: GoogleFonts.poppins(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                              direction: Axis.vertical,
                              spacing: -30,
                              children: [
                                Consumer<TimeProvider>(
                                    builder: (context, val, child) {
                                  return Text(
                                    val.time,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 70),
                                  );
                                }),

                                Consumer<TimeProvider>(
                                    builder: ((context, value, child) {
                                  return Text(
                                    value.month,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 70),
                                  );
                                }))
                                //   Text("OCT",
                                // style: GoogleFonts.poppins(
                                //   fontWeight: FontWeight.w500,
                                //   fontSize: 75
                                // ),
                                // ),
                              ]),
                        ],
                      ),
                      const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        indent: 30,
                        endIndent: 30,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('h:mm a').format(DateTime.now()),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "New York ",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('h:mm a').format(DateTime.now().toUtc()),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "UK",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
