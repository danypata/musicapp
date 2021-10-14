extension IntFormat on int {
  String timeString() {
    Duration duration = Duration(seconds: this.abs());

    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    if (seconds > 0) {
      return "$minutes min $seconds sec";
    }
    return "$minutes min";
  }
}
