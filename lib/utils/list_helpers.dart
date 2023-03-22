extension ListExtension on List {
  List<T> intersection<T>(List<T> otherList) {
    return otherList.where((element) => contains(element)).toList();
  }
}
