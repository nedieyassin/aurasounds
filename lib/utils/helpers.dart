formatDuration(Duration d){
  String hours = d.inHours.toString().padLeft(0, '2');
  String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  if(int.parse(hours) == 0){
    return "$minutes:$seconds";
  }else{
    return "$hours:$minutes:$seconds";
  }
}
