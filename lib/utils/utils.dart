List<T> rotate<T>(List<T> list, int v) {
  if (list.isEmpty) return list;
  var i = v % list.length;
  return list.sublist(i)..addAll(list.sublist(0, i));
}
