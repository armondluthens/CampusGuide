/***
 * messages: object detected - all 3 vibrate twice
 *           turn right - right motor vibrates once for one second
 *           turn left - left motor vibrates once for one second
 *           move straight - center motor vibrates for one second
 *           turn around - center motor vibrates twice
 *           arrived - all 3 motors vibrate for one second
 */
typedef enum Messages{
  OBJECT_DETECTED,
  TURN_RIGHT,
  TURN_LEFT,
  MOVE_STRAIGHT,
  TURN_AROUND,
  ARRIVED
};
