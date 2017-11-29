# Final Report

When first starting my project, I fully intended to build a weather station that was powered by a solar panel that was rotatable on 2 axes.  This report will detail my process and my outcome.  However, my project followed a rather non-linear approach, so rather than detailing my entire process I will to walk you through each aspect and its individual process.
    
### Arduino Board
I started out with a simple Arduino Uno board.  It was effective until I started working with the servos.  As I understood it, the Arduino board could not power motors, as they required too much current and could damage the USB ports on both ends.  I ordered a motor controller (aka motor shield) that plugs directly into the Arduino, which had to be assembled.  It was relatively simple and had instructions as to what needed to be soldered where.  I ran into a problem where the motor controller removed my 3.3V pin (the Arduino gives you a 5V and a 3.3V out) and replaced it with a 9V out.  This was unacceptable and there was no simply way around it.  I ended up building a voltage divider out of two resistors, 10K and 3.3K ohms.  This reduced the 5V to about 3.5V or so.  Close enough, I figured.  I later replaced my voltage divider with a proper voltage regulator (which does not vary voltage when current is changed, and in my situation really didn’t affect much since the sensor draws a fairly consistent amount of current).  I learned is still a good practice, since a voltage divider operates based on ratios so the Vout will vary based on Vin while a voltage regulator will maintain voltage, as long as the Vin is greater than or equal to the voltage you’re trying to maintain.

After I bought the motor shield I realized that I’d also run out of pins to plug wires into. So I bought a bigger Ardunio (the Arduino Mega) which has upwards of 50 pins (as opposed to 20).  However, it turns out I didn’t need the motor shield at all.  If you supply the Arduino with a wall-adapter that can supply sufficient current, and don’t use USB power, the Arduino can move servos fine.  The motor controller is apparently intended for stepper motors and traditional DC motors and was no longer necessary.
Now that the motor controller wasn’t taking up a majority of my input pins anymore, the Arduino Mega became overkill and will use more power than I needed and was replaced with my previous board (the Uno).  Now that I had my 3.3V pin back, I also didn’t need the voltage regulator.  However, I kept the voltage regulator for the sake of simplicity as I didn’t want to have two power lines (a 5V and 3.3V), as the confusion over the two is what caused me to fry a previous barometric pressure sensor.

### Battery
I started by stress-testing some batteries to understand how much current I needed, as I had no idea how to measure current using my multimeter yet.  I used some alkaline 9V batteries which were a poor choice since alkaline batteries have a fairly linear voltage output when compared to life (while my later lead-acid battery has a rather flat voltage line over most of its life, and only drops until it’s near death).

I eventually settled on a 12V 7 amp-hour battery from RadioShack.  Having gotten a reasonable current measurement, I found a battery in the range of 8-12 volts.  The Arduino requires at least 7 volts to run and can accept up to 12.  I used a 12V battery and decided I would put a heatsink on the voltage regulator (which can overheat at voltages over 12) should it become a problem.

The decision for 7 amp-hours was made to give the device a lifespan on pure battery power of about 2 days.

### Servos
I bought my servos around the first week of February, and having no idea what I was doing, just bought some hobby servos classified as “small.”  They were relatively cheap so I went for it.  More on this later.  I ended up buying two pan-tilt adapter plates for these servos.  The original kit I bought was small and was more intended for moving small cameras (think webcams).  The second kit also appeared to be more appropriate for cameras, but larger (think handheld cameras).  I did try to mount the solar panel onto the second kit and ended up grinding my servo gears.

Shortly after this I ordered my solar panel based on my current measurements (some 70mA idle and >300mA when moving).  When it arrived I realized my servos were grossly undersized.  At this time, I was already quite financially invested and decided to draw the line and only use one axis of movement, but get a stronger servo motor and strong adapter plate.

### Solar Panel
This project really drove home that solar power is pretty terrible.  Or, at least, my panel was terrible.  I had a talk with Dean Maggiotto at the annual Computer Science Banquet and he was a bit surprised at my panel’s efficiency, or lack thereof.  Ultimately, it’s not that solar power isn’t enough, it’s more than it’s unreliable.  It’s hard to capture a reliable amount of power from a panel when a cloudy day could lower your average wattage over the day significantly.

### Software
The software wasn’t extremely complicated.  The hardest part was avoiding floating point numbers since Ardunio’s don’t have specialized floating point processors so using too many floats can slow down the board.  Additionally, I was using sprintf to format my strings and it cannot format floats in the I/O package Arduino includes.  I opted to use fixed-point precision by simply multiplying the floating point values by 10 and casting them to integers.  Printing the values involved simply dividing by 10 to get the significant digits and then using modulus division to get the decimal point numbers.

Reading the the sensors didn’t give me a lot of grief.  Although the temperature sensor, for some reason, has to have about 4 seconds to “warm up” and can only be read every 2 seconds.  This posed a problem since the LCD has to be updated with every cycle or else you get scrolling gibberish on the display.  I overcame this by using a very crude “time sharing” system, if you can even call it that.  The Arduino keeps track of milliseconds since boot in a long integer.  The program keeps track of the millisecond value (millis()) when the sensor was last read (“lastDisplay” variable).  If the difference between millis() and lastDisplay is greater than the frequency the sensor needs to be read, that block of code is executed.  I used this bloc of code not only to read the sensor, but to also move the solar panel servo, since the servo doesn’t need to move contiously this allowed me to save power.  In fact, the servo could be moved even less frequently (perhaps upwards of every 5 minutes) to stretch power savings.