class Break{
  final DateTime start;
  final DateTime end;

  Break(this.start, this.end);

  Duration breakTime(){
    return this.end.difference(this.start);
  }
}