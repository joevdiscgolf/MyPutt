import 'package:flutter/material.dart';
import 'package:myputt/components/misc/custom_fade_shimmer.dart';
import 'package:myputt/utils/layout_helpers.dart';

class SessionLoadingScreen extends StatelessWidget {
  const SessionLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = addRunSpacing(
      [
        for (int i = 0; i < 5; i++)
          const Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CustomFadeShimmer(
                    height: 72,
                    width: double.infinity,
                    radius: 8,
                  ),
                ),
              ),
            ],
          )
      ],
      runSpacing: 16,
      axis: Axis.vertical,
    );
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return children[index];
      },
      itemCount: children.length,
    );
  }
}
