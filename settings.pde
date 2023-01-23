#include "FS.h"

#define FILE_SETTINGS "/settings.cfg"

void initFS()
{
  SPIFFSConfig configFS;
  configFS.setAutoFormat(false);
  SPIFFS.setConfig(configFS);

  if (!SPIFFS.begin()) {
    debug("ERORR SPIFFS");
  }
}

bool existsSettings() 
{
  return SPIFFS.exists(FILE_SETTINGS);
}

void initSettings() 
{  
  File fileSettings = SPIFFS.open(FILE_SETTINGS, "r");

  uint16_t bytesRead = fileSettings.read((byte *) &Settings, sizeof(Settings));

  debug("read file settings ssid:" + (String) Settings.ssid + " password:" + (String) Settings.password);
  
  fileSettings.close();
}

void setSettings(String ssid, String password) 
{
  File fileSettings = SPIFFS.open(FILE_SETTINGS, "w+");

  if (!fileSettings) {
    debug("file settings open failed");  

    String message = "{\"status\":\"ERROR\", \"message\": \"File settings open failed\"}";
    server.send(500, "application/json", message);
    return;
  }

  debug("write to settings ssid:" + ssid + " password:" + password);
  
  ssid.toCharArray(Settings.ssid, 36);
  password.toCharArray(Settings.password, 36);
  uint16_t bytesWrite = fileSettings.write((byte *) &Settings, sizeof(Settings));

  fileSettings.close();
}

void resetSettings()
{
  SPIFFS.remove(FILE_SETTINGS);
}
