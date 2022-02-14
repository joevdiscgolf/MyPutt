bool validUsername(String? value) {
  if (value == null ||
      value.trim().length < 3 ||
      value.trim().length > 20 ||
      value.trim().contains(' ')) {
    return false;
  }
  return true;
}
