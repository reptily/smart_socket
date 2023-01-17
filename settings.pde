#include "LittleFS.h" 

#define FILE_SETTINGS "/settings.cfg"

void initFS()
{
  LittleFS.begin();
}

bool existsSettings() 
{
  return LittleFS.exists(FILE_SETTINGS);
}

void initSettings() 
{  
  File fileSettings = LittleFS.open(FILE_SETTINGS, "r");
  String settings[2];

  uint16_t bytesRead = fileSettings.read((byte *) &Settings, sizeof(Settings));
  settings[0] = Settings.ssid;
  settings[1] = Settings.password;

  debug("read file settings ssid:" + settings[0] + " password:" + settings[1]);
  
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

  debug("write to settings ssid:" + ssid + " password:" + password);
  
  ssid.toCharArray(Settings.ssid, 36);
  password.toCharArray(Settings.password, 36);
  uint16_t bytesWrite = fileSettings.write((byte *) &Settings, sizeof(Settings));

  fileSettings.close();
}

void resetSettings()
{
  LittleFS.remove(FILE_SETTINGS);
}