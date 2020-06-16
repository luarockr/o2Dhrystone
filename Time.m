MODULE Time;

IMPORT oocTime;

PROCEDURE Now*() : LONGINT;
VAR ts : oocTime.TimeStamp;
BEGIN
  oocTime.GetTime(ts);
  RETURN ts.msecs;
END Now;


BEGIN

END Time.
