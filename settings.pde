#include "LittleFS.h"

#define FILE_SETTINGS "/settings.cfg"

void initFS()
{
  if (!LittleFS.begin()) {
    debug("ERORR FS");
  } else {
    debug("FS init OK");
  }
}

bool existsSettings() 
{
  return LittleFS.exists(FILE_SETTINGS);
}

void initSettings() 
{   
  File fileSettings = LittleFS.open(FILE_SETTINGS, "r");

  uint16_t bytesRead = fileSettings.read((byte *) &Settings, sizeof(Settings));

  debug("read file settings ssid:" + (String) Settings.ssid + " password:" + (String) Settings.password);
  
  fileSettings.close();
}

void setSettings(String ssid, String password) 
{
  File fileSettings = LittleFS.open(FILE_SETTINGS, "w+");

  if (!fileSettings) {
    debug("file settings open failed");  

    String message = "{\"status\":\"ERROR\", \"message\": \"File settings open failed\"}";
    server.send(500, "application/json", message);
    return;
  }
  
  ssid.toCharArray(Settings.ssid, 36);
  password.toCharArray(Settings.password, 36);

  fileSettings.write((byte *) &Settings, sizeof(Settings));
  fileSettings.close();

  debug("write to settings ssid:" + ssid + " password:" + password);
}

void resetSettings()
{
  LittleFS.remove(FILE_SETTINGS);
  debug("Reset settings");
}
