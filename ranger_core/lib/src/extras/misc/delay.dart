class Delay {
  double timeCnt = 0.0;
  double duration = 0.0; // in milliseconds

  Delay();

  factory Delay.create(double duration) => Delay()..duration = duration;

  void reset() => timeCnt = 0.0;

  bool expired(double dt) {
    timeCnt += dt;
    return timeCnt > duration;
  }
}
