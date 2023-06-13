extension SafeList<T> on List<T> {
  List<T> safeSubList(int startIndex, int endIndex) {
    final List<T> newList = [];

    for (int i = 0; i < endIndex; i++) {
      if (i < length) {
        newList.add(this[i]);
      } else {
        break;
      }
    }
    return newList;
  }
}

T? tryCast<T>(dynamic x) {
  try {
    return (x as T);
  } on TypeError catch (_) {
    return null;
  }
}
