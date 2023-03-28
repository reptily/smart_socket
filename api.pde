#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <ESP8266WiFi.h>
#define SERVER_PORT 80

ESP8266WebServer server(SERVER_PORT);

void routes()
{
  server.on("/test", handleTest);
  server.on("/restart", handleReset);
  server.on("/set_switch", handleSetSwitch);
  server.on("/wifi/update_setting", handleWifiUpdateSetting);
  server.on("/wifi/reset_setting", handleWifiResetSetting);
}

void createHttpServer() {
  routes();
  server.begin();
  debug("HTTP server started");
}

void listen()
{
  server.handleClient();
  MDNS.update();
}

bool validate(int typeMethod)
{
  if (server.method() != typeMethod) {
    String message = "{\"status\":\"ERROR\", \"message\": \"Request method not supported\"}";
    server.send(400, "application/json", message);
    
    return false;
  }

  return true;
}

void handleTest() 
{ 
  String message = "{\"status\":\"OK\"}";
  server.send(200, "application/json", message);
}

void handleSetSwitch() 
{
  if (!validate(HTTP_POST)) {
    return;
  }

  String isActiveParam = server.arg("is_active");
  bool isActive = StringToBool(isActiveParam);

  debug("is active:" + isActive);

  String message = "{\"status\":\"OK\", \"message\": \"Smart socket set active\"}";
  server.send(200, "application/json", message); 

  setActiveSmartSocket(isActive);
}

void handleWifiUpdateSetting() 
{
  if (!validate(HTTP_POST)) {
    return;
  }

  String ssid = server.arg("ssid");
  String password = server.arg("password");

  setSettings(ssid, password);

  String message = "{\"status\":\"OK\", \"message\": \"Settings is saved\"}";
  server.send(200, "application/json", message); 

  delay(3000);
  ESP.restart();
}

void handleWifiResetSetting() 
{
  if (!validate(HTTP_DELETE)) {
    return;
  }

  resetSettings();

  String message = "{\"status\":\"OK\", \"message\": \"Settings is reset\"}";
  server.send(200, "application/json", message); 

  restart();
} 

void handleReset() 
{
  if (!validate(HTTP_GET)) {
    return;
  }

  String message = "{\"status\":\"OK\", \"message\": \"Device is reset\"}";
  server.send(200, "application/json", message); 

  restart();
} 
