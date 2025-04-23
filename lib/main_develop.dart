import 'package:homewidgetdemo/constant.dart';
import 'package:homewidgetdemo/main.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.dev,
    values: FlavorValues(
      enableLogging: true,
      widgetGroupId: Constant().appGroupId,
      widgetSchemePrefix: 'homeWidgetCounterDev',
      widgetPrefix: 'Dev',
      keySuffix: '_Dev',
    ),
  );
  mainInit();
}