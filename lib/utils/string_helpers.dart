int versionToNumber(String version) {
  final withoutDots = version.replaceAll(RegExp('\\.'), ''); // abc
  return int.parse(withoutDots);
}
