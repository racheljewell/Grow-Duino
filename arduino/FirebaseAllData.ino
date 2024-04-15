#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include <NTPClient.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include "DHT.h"
#include <Credentials.h>

// set up sensor pins
#define DHTPIN D5
#define DHTTYPE DHT22
int light_sensor1 = A0; 
DHT dht(DHTPIN, DHTTYPE);

// declare client for time tracking
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

// get wifi credentials
const char* ssid = STASSID;
const char* password = STAPSK;

const int UPDATE_DELAY = 1000 * 60; // 1 minute delay between updates

// Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

void setup() {
  Serial.begin(115200);
  dht.begin();
  timeClient.begin();
  timeClient.setTimeOffset(-18000); // 3600 seconds per hour * -5 hours from GMT time = -18000 offset
  Serial.println("Booting");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("Connection Failed! Rebooting...");
    Serial.print(ssid);
    Serial.print(" ");
    Serial.println(password);
    delay(5000);
    ESP.restart();
  }

  // Port defaults to 8266
  // ArduinoOTA.setPort(8266);

  // Hostname defaults to esp8266-[ChipID]
  // ArduinoOTA.setHostname("myesp8266");

  // No authentication by default
  // ArduinoOTA.setPassword("admin");

  // Password can be set with it's md5 value as well
  // MD5(admin) = 21232f297a57a5a743894a0e4a801fc3
  // ArduinoOTA.setPasswordHash("21232f297a57a5a743894a0e4a801fc3");

  ArduinoOTA.onStart([]() {
    String type;
    if (ArduinoOTA.getCommand() == U_FLASH) {
      type = "sketch";
    } else { // U_SPIFFS
      type = "filesystem";
    }

    // NOTE: if updating SPIFFS this would be the place to unmount SPIFFS using SPIFFS.end()
    Serial.println("Start updating " + type);
  });
  ArduinoOTA.onEnd([]() {
    Serial.println("\nEnd");
  });
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
    Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
  });
  ArduinoOTA.onError([](ota_error_t error) {
    Serial.printf("Error[%u]: ", error);
    if (error == OTA_AUTH_ERROR) {
      Serial.println("Auth Failed");
    } else if (error == OTA_BEGIN_ERROR) {
      Serial.println("Begin Failed");
    } else if (error == OTA_CONNECT_ERROR) {
      Serial.println("Connect Failed");
    } else if (error == OTA_RECEIVE_ERROR) {
      Serial.println("Receive Failed");
    } else if (error == OTA_END_ERROR) {
      Serial.println("End Failed");
    }
  });
  ArduinoOTA.begin();
  Serial.println("Ready");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  // configure firebase connection
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  Firebase.reconnectNetwork(true); 
  fbdo.setBSSLBufferSize(4096, 1024); 
  fbdo.setResponseSize(2048); 

  // begin firebase connection
  Firebase.begin(&config, &auth);

}

// create random document name
String generateHash(long x)
{
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = (x >> 16) ^ x;
    return String(x);
}

void loop() {
  ArduinoOTA.handle();

  timeClient.update();


  // get data to be sent to database :
  // time, light level, humidity, temperature
  unsigned long epochTime = timeClient.getEpochTime();
  int raw_light1 = analogRead(light_sensor1);
  int light1 = map(raw_light1, 0, 1023, 100, 0);
  float humi  = dht.readHumidity();
  float tempF = dht.readTemperature(true);

  String documentHash = generateHash(epochTime);

  // set path of document to be updated
  // '%20' used to replace space in path
  String documentPath = "arduino_data/" + documentHash;

  // create update data
  FirebaseJson content;

  // content to create new document in arduino_data collection
  content.set("fields/arduino_id/stringValue", "arduino1");
  content.set("fields/packet/mapValue/fields/humidity/doubleValue", humi);
  content.set("fields/packet/mapValue/fields/light_sensor1/integerValue", light1);
  content.set("fields/packet/mapValue/fields/temperature/doubleValue", tempF);
  content.set("fields/timestamp/integerValue", epochTime);

  // create new document in Firebase
  if(Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw()))
    Serial.print("Update Successful");
  else
    Serial.print(fbdo.errorReason());
  delay(UPDATE_DELAY);
}
