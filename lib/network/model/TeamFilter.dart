class TeamFilter {
  final int minRange;
  final int maxRange;
  final bool? isPrivate;
  final int minMembersCount;
  final int maxMembersCount;
  final String search;
  final int sort;
  final int division;

  TeamFilter(
      {this.minRange = 100,
      this.maxRange = 3500,
      this.isPrivate,
      this.minMembersCount = 1,
      this.maxMembersCount = 11,
      this.search = "",
      this.sort = 0,
      this.division = 0});
}
