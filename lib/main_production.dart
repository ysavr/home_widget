import 'constant.dart';
import 'flavor_config.dart';
import 'main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.dev,
    values: FlavorValues(
      enableLogging: true,
      widgetGroupId: Constant().appGroupId,
      widgetSchemePrefix: 'homeWidgetCounter',
      widgetPrefix: '',
      keySuffix: '',
    ),
  );
  mainInit();
}