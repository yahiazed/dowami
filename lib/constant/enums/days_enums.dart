enum Days {
  sunday("Su", 0),
  monday("Mo", 1),
  tuesday("Tu", 2),
  wednesday("W", 3),
  thursday("Th", 4),
  friday("Fr", 5),
  saturday("Sa", 6);

  const Days(this.name, this.value);
  final String name;
  final int value;
}

enum DaysAr {
  sunday("ح", 0),
  monday("ات", 1),
  tuesday("ث", 2),
  wednesday("ر", 3),
  thursday("خ", 4),
  friday("ج", 5),
  saturday("س", 6);

  const DaysAr(this.name, this.value);
  final String name;
  final int value;
}
