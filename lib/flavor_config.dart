enum Flavor {
  dev,
  staging,
  prod,
}

class FlavorValues {
  final bool enableLogging;
  final String widgetGroupId;
  final String widgetSchemePrefix;
  final String widgetPrefix;
  final String keySuffix;

  FlavorValues({
    required this.enableLogging,
    required this.widgetGroupId,
    required this.widgetSchemePrefix,
    required this.widgetPrefix,
    required this.keySuffix,
  });
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(flavor, values);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isProd() => _instance!.flavor == Flavor.prod;
  static bool isDev() => _instance!.flavor == Flavor.dev;
}