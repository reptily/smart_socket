#include <stdio.h>
#include <string.h>

#define SERIAL_SPEED_RATE 9600
#define PIN_SMART_SOCKET 13 // d7
#define PIN_SIGNAL_WIFI_LAMP 14 //d5
#define PIN_RESET_BUTTON 12 // d6

#define DEBUG_PRING true
#define MSECONDS_AFTER_RESTART 3000

/**
 * Board - esp8266 -> NodeMCU 1.0 (ESP-12E Mocule)
 *
 * Preferences -> Bords URL -> http://arduino.esp8266.com/stable/package_esp8266com_index.json
 * Boards manager -> esp8266
 */

struct SettingsStruct {
  char ssid[36];
  char password[36];
};

SettingsStruct Settings {
  "wifi",
  "12345678"    
};

bool gIsActive = false;

void setup() 
{
  Serial.begin(SERIAL_SPEED_RATE);

  pinMode(PIN_SMART_SOCKET, OUTPUT);
  pinMode(PIN_SIGNAL_WIFI_LAMP, OUTPUT);  
  pinMode(PIN_RESET_BUTTON, INPUT);

  initFS();
  index();
}

void index() 
{
  if (!existsSettings()) {
    debug("File settings not found");
    startAP();
    
    return;
  }  

  initSettings();
  startSTA(Settings.ssid, Settings.password);
}

void loop() 
{
  if (digitalRead(PIN_RESET_BUTTON) == LOW) {
    resetSettings();
    restart();
  }

  listen();
}

void setActiveSmartSocket(bool isActive) 
{
  if (isActive) {
    gIsActive = true;
    debug("switch on");
    digitalWrite(PIN_SMART_SOCKET, HIGH);
  } else {
    gIsActive = false;
    debug("switch off");
    digitalWrite(PIN_SMART_SOCKET, LOW);
  }
}

bool getActiveSmartSocket()
{
  return gIsActive;
}

void restart()
{
  delay(MSECONDS_AFTER_RESTART);
  ESP.restart();
}
