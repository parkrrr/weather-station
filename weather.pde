#include <LiquidCrystal.h>
#include <DHT22.h>
#include <BMP085.h>
#include <Wire.h>
#include <Servo.h>

#define WARMUP_TIME 4 // Needed to let some sensors figure thesmelves out, see setup()
#define DHT22_PIN 8
#define WARNING_LED_PIN 13
#define LCD_COLS 16
#define LCD_ROWS 2
#define UPDATE_TIME 2500 // in milliseconds

// Servo values
#define UPPER 120
#define MID 90
#define LOWER 60

#define LEFT 0
#define CENTER 1
#define RIGHT 2

boolean DEBUG = false;
boolean ServoDEBUG = false;

boolean useCelsius = false;
boolean usePascals = false;
LiquidCrystal lcd(7, 6, 2, 3, 4, 5);
DHT22 myDHT22(DHT22_PIN);
BMP085 dps;
char buffer[LCD_COLS];
unsigned long lastDisplay;

Servo pitch;

int angle;
int sensors[3];

float fPressure = 0.0f;
float fAltitude = 285.0f;
float fTemp = 0.0f;

// Converts Celsius unit to Fahrenheit
// Returns fixed point integers
int toFahrenheit(float temp)
{
  float newTemp = (temp * (1.8)) + 32;
  newTemp *= 10;
  return (int) newTemp;
}

// Set up serial port if needed
// Also give sensors time to calibrate
void setup()
{ 
  lcd.begin(LCD_COLS, LCD_ROWS);
  Wire.begin();
  pitch.attach(10);              
  pinMode(WARNING_LED_PIN, OUTPUT);

  // Standard sampling rate @ 285 meters above sea level, using meters
  dps.init(MODE_STANDARD, fAltitude, true);

  if (DEBUG) Serial.begin(9600);

  /* Simply handles a initialization.  The DHT22 sensor wants a bit of a delay
   * before it can be read so we just sit patiently for awhile.
   */
  int progress = 0;
  int step = 100/WARMUP_TIME;
  lcd.setCursor(0, 0);
  sprintf(buffer,"Warming up: %3ds", WARMUP_TIME);
  lcd.print(buffer);
  for (int i = 0; i < WARMUP_TIME; i++)
  {
    lcd.setCursor(0, 1);
    sprintf(buffer,"%15d%%", progress);
    lcd.print(buffer);
    delay(500);
    progress += step;
  }
  lcd.clear();
}

void loop()
{
  DHT22_ERROR_t errorCode = DHT_ERROR_NONE;

  sensors[LEFT] = analogRead(0) + 1;
  sensors[RIGHT] = analogRead(2) + 1;
  sensors[CENTER] = analogRead(1) + 1;

  boolean goLeft = false;
  if (sensors[LEFT] > sensors[CENTER]) goLeft = true;

  float maxValue = sensors[RIGHT];
  float medValue = sensors[CENTER];
  int maxAngle = LOWER;
  int medAngle = MID;

  if (goLeft) {
    maxAngle = UPPER;
    maxValue = sensors[LEFT];
  }

  float angleRatio = medValue / maxValue;
  float inverseRatio = 1 - angleRatio;
  float modifier = 30 * inverseRatio;

  if (goLeft) {
    angle = MID - (int) modifier;
  } 
  else {
    angle = MID + (int) modifier;
  }

  if (millis()-lastDisplay>UPDATE_TIME) {
    errorCode = myDHT22.readData();
    dps.getPressure(&fPressure);
    dps.calcTrueTemperature();
    dps.getTemperature(&fTemp);
    lastDisplay = millis();
    pitch.write(angle);
  }

  if (ServoDEBUG) {
    sprintf(buffer,"L=%4d    R=%4d", sensors[LEFT], sensors[RIGHT]);
    lcd.setCursor(0, 0);
    lcd.print(buffer);

    sprintf(buffer,"Ang=%3d   C=%4d", angle,sensors[CENTER]);
    lcd.setCursor(0, 1);
    lcd.print(buffer);
  }
  else { 
    if(errorCode == DHT_ERROR_NONE)
    {
      digitalWrite(WARNING_LED_PIN, LOW); 
      int humid = (int) (myDHT22.getHumidity() * 10);
      int pressure = (int) ((fPressure / 33.86) * 100);

      if (useCelsius)
      {
        int DHT22temp = (int) (myDHT22.getTemperatureC() * 10);
        int BMP85temp = (int) (fTemp * 10);
        int temp = ((DHT22temp + BMP85temp) / 2);
        sprintf(buffer,"T%3d.%dC  H%3d.%d%%", temp/10, temp%10,humid/10,humid%10);
      }
      else
      {    
        int DHT22temp = myDHT22.getTemperatureC();
        int BMP85temp = fTemp;
        int temp = toFahrenheit(((DHT22temp + BMP85temp) / 2));

        sprintf(buffer,"T%3d.%dF  H%3d.%d%%", temp/10,temp%10,humid/10,humid%10);
      }
      lcd.setCursor(0, 0);
      lcd.print(buffer);

      sprintf(buffer,"P %02d.%02d\" Hg A%3d", pressure/100,pressure%100, angle);
      lcd.setCursor(0, 1);
      lcd.print(buffer);
    }
    else {
      digitalWrite(WARNING_LED_PIN, HIGH);
      if (DEBUG)
      {
        char serialBuffer[24];
        sprintf(serialBuffer,"Got DHT error code");
        Serial.println(serialBuffer);
      }
    }
  }
}
