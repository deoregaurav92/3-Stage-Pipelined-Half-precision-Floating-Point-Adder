#include <LiquidCrystal.h>
int pin7  = 7;
int pin8  = 8;
int Contrast  = 90;
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

 void setup()
 {
    pinMode(pin7,INPUT);
    pinMode(pin8,INPUT);
    analogWrite(6,Contrast);
    lcd.begin(16, 2);
 }
void loop()
 {
    while(1)
    {
      while((digitalRead(pin8)==0) && (digitalRead(pin7)==0))
      {
        lcd.setCursor(0,0);
        lcd.print("Reset");
      }
      lcd.clear();
      while((digitalRead(pin8)==0) && (digitalRead(pin7)==1))
      {
        lcd.setCursor(0,0);
        lcd.print("Input 1");
      }
      lcd.clear();
      while((digitalRead(pin8)==1) && (digitalRead(pin7)==0))
      {
        lcd.setCursor(0,0);
        lcd.print("Input 2");
      }
      lcd.clear();
      while((digitalRead(pin8)==1) && (digitalRead(pin7)==1))
      {
        lcd.setCursor(0,0);
        lcd.print("FP Output");
      }
      lcd.clear();
  }
 }
