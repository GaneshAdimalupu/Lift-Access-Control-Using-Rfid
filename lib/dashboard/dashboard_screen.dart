import 'package:flutter/material.dart';
import 'package:flutter_auth/responsive.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'components/lift_usage_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                       LiftUsageChart(),
                      const SizedBox(height: defaultPadding),
                      // Empty container instead of RecentFiles()
                      Container(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        // Empty container instead of StorageDetails()
                        Container(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: Container(), // Empty container
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
