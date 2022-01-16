import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/screens/record_putting/components/putting_set_row.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static String routeName = '/record_screen';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final PuttingSession _session =
      PuttingSession(dateStarted: 'today', uid: 'myuid');

  int _focusedIndex = 0;
  int _setLength = 10;
  int? _distance;

  int _weatherIndex = 0;
  int _windIndex = 0;

  final List<String> _windConditionWords = [
    'Calm',
    'Breezy',
    'Strong',
    'Intense',
  ];
  final List<String> _weatherConditionWords = [
    'Sunny',
    'Rainy',
    'Snowy',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisSize: MainAxisSize.min,
              children: [
                _conditionsPanel(context),
                const SizedBox(height: 20),
                const Text('Putts made',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                _puttsMadePicker(context),
                PrimaryButton(
                    label: 'Finish set',
                    width: double.infinity,
                    height: 50,
                    icon: FlutterRemix.arrow_right_line,
                    onPressed: () {
                      print(_focusedIndex);
                      setState(() {
                        _session.sets.add(PuttingSet(
                            puttsMade: _focusedIndex + 1,
                            puttsAttempted: _setLength,
                            distance: _distance ?? 10));
                      });
                    }),
                _previousSetsList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _conditionsPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  const Text('Wind',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  PrimaryButton(
                    height: 40,
                    width: 80,
                    label: _windConditionWords[_windIndex],
                    fontSize: 12,
                    onPressed: () {
                      setState(() {
                        if (_windIndex == 3) {
                          _windIndex = 0;
                        } else {
                          _windIndex += 1;
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  const Text('Weather',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  PrimaryButton(
                    height: 40,
                    width: 80,
                    label: _weatherConditionWords[_weatherIndex],
                    fontSize: 12,
                    onPressed: () {
                      setState(() {
                        if (_weatherIndex == 2) {
                          _weatherIndex = 0;
                        } else {
                          _weatherIndex += 1;
                        }
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                child: const Text('-',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _setLength -= 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                ),
              ),
              const SizedBox(width: 5),
              Text(_setLength.toString()),
              //const SizedBox(width: 5),
              ElevatedButton(
                child: const Text('+',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _setLength += 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _puttsMadePicker(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(20),
      child: ScrollSnapList(
        itemSize: 80,
        itemCount: _setLength + 2,
        duration: 80,
        focusOnItemTap: true,
        onItemFocus: _onItemFocus,
        itemBuilder: _buildListItem,
        dynamicItemSize: true,
        allowAnotherDirection: true,
        dynamicSizeEquation: (displacement) {
          const threshold = 0;
          const maxDisplacement = 700;
          if (displacement >= threshold) {
            const slope = 1 / (-maxDisplacement);
            return slope * displacement + (1 - slope * threshold);
          } else {
            const slope = 1 / (maxDisplacement);
            return slope * displacement + (1 - slope * threshold);
          }
        },
        // dynamicSizeEquation: customEquation, //optional
      ),
    );
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (index >= _setLength) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
          color: index == _focusedIndex
              ? Colors.lightBlueAccent
              : Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey[600]!)),
      width: 80,
      child: Center(
          child: Text((index + 1).toString(),
              style: TextStyle(
                  color: index == _focusedIndex ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
    );
  }

  Widget _previousSetsList(BuildContext context) {
    return Container(
      child: Column(
        children: _session.sets.map((set) => PuttingSetRow(set: set)).toList(),
      ),
    );
  }
}
