class Group implements Comparable{
  final int id;
  final String name;

  Group(this.id, this.name);

  @override
  int compareTo(other) {
    if (other is! Group) {
      return -1;
    } else {
      return other.id.compareTo(id);
    }
  }

}