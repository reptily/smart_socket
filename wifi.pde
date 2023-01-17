#include <WiFiClient.h>

#define DEFAULT_WIFI_SSID "Smart-Socker-001"
#define DEFAULT_WIFI_PASSWORD "12345678"

#define RETRY_CONNECT 5000

IPAddress localIP(192, 168, 1, 1);
IPAddress gateway(192, 168, 1, 2);
IPAddress subnet(255, 255, 255, 0);

void startAP() 
{
  debug("Starting AP");
  WiFi.softAPConfig(localIP, gateway, subnet);
  WiFi.softAP(DEFAULT_WIFI_SSID, DEFAULT_WIFI_PASSWORD);

  createHttpServer();
} 

void startSTA(String ssid, String password) 
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid.c_str(), password.c_str());

  while (WiFi.status() != WL_CONNECTED) {
    digitalWrite(PIN_SIGNAL_WIFI_LAMP, LOW);
    delay(RETRY_CONNECT);
    yield();
    debug(".");
  }

  digitalWrite(PIN_SIGNAL_WIFI_LAMP, HIGH);
  debug("Connected to " + ssid);
  debug("IP address: " + WiFi.localIP().toString());

  if (MDNS.begin("esp8266")) {
    debug("MDNS responder started");
  }

  createHttpServer();
}

