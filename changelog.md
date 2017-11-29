# Changelog

### 1/22/10
* Implemented DHT-22 temperature/humidity sensor
* Made LCD panel functional

### 1/28/10
* Fixed the "too quick" reading error
* Code was running 30-100 times each iteration when it should have only been running once

### 1/29/10
* Added barometric pressure sensor
* Added 9V adapter

### 1/31/10
* Assembled motor shield

### 2/1/10
* Drilled holes into board, mounted Arduino Mega
* Reduced data lines to LCD from 8 to 4
* Tidied up board

### 2/5/10
* Measured current without servos: 175 mA
* With servos: Peak around 400 mA, low at 270 mA
* Condensed board, added resistors to power the BMP085.  Only one source for power from board now.
* Managed a crude proof-of-concept for servos moving based on photoresistor value.

### 2/6/10
* Explored housing possibilities.  [Stevenson screen](https://en.wikipedia.org/wiki/Stevenson_screen), perhaps.

### Stuff left to do:
* Figure out charging mechanism
* Determine true amperage at load
* Order solar panels
* Build Stevenson screen
* Acquire weather-proof housing, as well as a durable outer housing