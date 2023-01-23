import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '5',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: MyPuttColors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: ' sets completed',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: MyPuttColors.darkGray,
                          fontWeight: FontWeight.w600,
                        ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(color: MyPuttColors.gray[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '60%',
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: MyPuttColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Percentage',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: MyPuttColors.gray[300]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(color: MyPuttColors.gray[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '5',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    color: MyPuttColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            TextSpan(
                              text: '/10',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    color: MyPuttColors.darkGray,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Putts made',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: MyPuttColors.gray[300]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
