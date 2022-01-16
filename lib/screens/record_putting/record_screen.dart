import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/data/types/putting_set_data.dart';
import 'package:myputt/screens/record_putting/components/putting_set_row.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static String routeName = '/record_screen';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int _focusedIndex = 0;
  int _setLength = 10;
  int _distance = 10;
  List<PuttingSetData> _sets = [];

  @override
  Widget build(BuildContext context) {
    return Center(
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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            _puttsMadePicker(context),
            PrimaryButton(
                label: 'Next',
                icon: FlutterRemix.arrow_right_line,
                onPressed: () {
                  setState(() {
                    _sets.add(PuttingSetData(
                        puttsMade: _focusedIndex + 1,
                        puttsAttempted: _setLength,
                        distance: _distance));
                  });
                }),
            _previousSetsList(context),
          ],
        ),
      ),
    );
  }

  Widget _conditionsPanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Text('Sunny'),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Text('Windy'),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Text('10 putters'),
              )
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
        duration: 100,
        focusOnItemTap: true,
        onItemFocus: _onItemFocus,
        itemBuilder: _buildListItem,
        dynamicItemSize: true,
        allowAnotherDirection: true,
        dynamicSizeEquation: (displacement) {
          const threshold = 0;
          const maxDisplacement = 400;
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
        children: _sets.map((set) => PuttingSetRow(set: set)).toList(),
      ),
    );
  }
}
