import 'package:flutter/material.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:night_gschallenge/providers/audio_provider.dart';
import 'package:night_gschallenge/providers/count_down_provider.dart';
import 'package:night_gschallenge/screens/menu/MeditationTimer/count_down_timer.dart';
import 'package:night_gschallenge/screens/menu/MeditationTimer/time_picker.dart';
import 'package:night_gschallenge/screens/menu/MentalExercise/mental_exercise_solutions.dart';
import 'package:night_gschallenge/widgets/UI/ListTileIconCreators.dart';
import 'package:night_gschallenge/widgets/UI/elevated_button_without_icon.dart';
import 'package:night_gschallenge/widgets/UI/home_screen_heading.dart';
import 'package:night_gschallenge/widgets/UI/top_row.dart';
import 'package:provider/provider.dart';

class MeditationTimer extends StatefulWidget {
  static String routeName = '/meditation';
  bool isShowPicker;
  late DateTime datetime;
  int selectedIndex;
  MeditationTimer({this.isShowPicker = true, this.selectedIndex = 0});
  List<Map<dynamic, dynamic>> options = [
    {
      'icon': Icons.notifications,
      'title': 'Default',
      'music': 'assets/default.mp3'
    },
    {'icon': Icons.forest, 'title': 'Forest', 'music': 'assets/forest.mp3'},
    {
      'icon': Icons.nightlight,
      'title': 'Summer Night',
      'music': 'assets/summer_night.mp3'
    },
    {
      'icon': Icons.beach_access_rounded,
      'title': 'Beach',
      'music': 'assets/beach.mp3'
    },
    {
      'icon': Icons.nightlife,
      'title': 'Summer Rain',
      'music': 'assets/summer_rain.mp3'
    },
    {
      'icon': Icons.fireplace,
      'title': 'Stove Fire',
      'music': 'assets/stove_fire.mp3'
    },
  ];

  @override
  State<MeditationTimer> createState() => _MeditationTimerState();
}

class _MeditationTimerState extends State<MeditationTimer> {
  void handleClick() {
    setState(() {
      widget.isShowPicker = !widget.isShowPicker;
    });
  }

  void callBackDateTime(DateTime datetime) {
    setState(() {
      widget.datetime = datetime;
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<CountDownProvider>(context);
    var audio = Provider.of<AudioProvider>(context);
    return Scaffold(
      body: ListView(
        children: [
          TopRow(
            back: true,
          ),
          HomeScreenText(
            text: 'Meditation Timer',
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 200,
                  child: Image.asset(
                    "assets/meditation_timer_person.gif",
                    fit: BoxFit.contain,
                  ),
                ),
                !widget.isShowPicker
                    ? CountDownTimerComponent(widget.datetime)
                    : TimePicker(callBackDateTime),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 100,
            child: !widget.isShowPicker
                ? Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: Column(children: [
                      Expanded(
                          child: Icon(
                              widget.options[widget.selectedIndex]['icon'])),
                      Expanded(
                          child: Text(
                              widget.options[widget.selectedIndex]['title']))
                    ]),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: widget.selectedIndex == index
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              )
                            : null,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedIndex = index;
                            });
                          },
                          child: Column(children: [
                            Expanded(
                                child: Icon(widget.options[index]['icon'])),
                            Expanded(
                                child: Text(widget.options[index]['title']))
                          ]),
                        ),
                      );
                    },
                    itemCount: widget.options.length,
                  ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!widget.isShowPicker)
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).canvasColor,
                    child: IconButton(
                      onPressed: () {
                        audio.stop();
                        setState(() {
                          widget.isShowPicker = !widget.isShowPicker;
                        });
                      },
                      icon: Icon(
                        Icons.stop_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).canvasColor,
                  child: IconButton(
                      onPressed: () {
                        if (!widget.isShowPicker) {
                          if (controller.isPause) {
                            controller.resume();
                            audio.resume();
                          } else {
                            controller.pause();
                            audio.pause();
                          }
                        } else {
                          handleClick();
                          audio.play(
                              widget.options[widget.selectedIndex]['music']);
                        }
                      },
                      icon: Icon(
                        !widget.isShowPicker
                            ? (controller.isPause
                                ? Icons.play_arrow
                                : Icons.pause)
                            : Icons.play_arrow,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
          ListTileIconCreators(
            icon: Icons.shape_line_outlined,
            title: 'Check out meditation exercises',
            onTap: () => Navigator.of(context).pushNamed(
              MentalExerciseSolution.routeName,
              arguments: 'MEDITATION',
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
