1. rotation
we can **try** using trig to find the angle theta.

tan(theta) = opposite / adjacent
tan(theta) = (y2-y1) / (x2-x1)
theta = atan((y2-y1) / (x2-x1))

however, this results in a division by 0 if x2-x1 = 0, or fails on edge cases. it also cannot know which quadrant it is in.

**solution:**
there is a common math function called atan2 (https://en.wikipedia.org/wiki/Atan2) which accepts 2 arguments, (y, x).

it should handle all cases, and it will return the angle just like atan, but it works for quadrants! we just need the y ( y2 - y1 ) and x ( x2 - x1 )

now, we got the angle theta, but that directly is not the rotation of the texture. since theta is going left from the positive x-axis (basically how unit circle works), we need to transform it so we can apply it to our texture.

in my case, turning left is negative, and turning right is positive, and 0 means upright and no tilt. so, we can just turn left theta degrees from 0, which translates to (0-theta)

**Formula:**
**rotation = 0 - (math.atan2( (y2 - y1), (x2 - x1) ))**