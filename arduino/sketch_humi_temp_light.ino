#include "DHT.h"
#define DHTPIN 2
#define DHTTYPE DHT22

int light_sensor1 = A0; 
int light_sensor2 = A1;

DHT dht(DHTPIN, DHTTYPE);

void setup() {
Serial.begin(9600); //begin Serial Communication
dht.begin();
}
 
void loop() {
  int raw_light1 = analogRead(light_sensor1); // read the raw value from light_sensor pin (A3)
  int raw_light2 = analogRead(light_sensor2); // read the raw value from light_sensor pin (A3)
  int light1 = map(raw_light1, 0, 1023, 100, 0); // map the value from 0, 1023 to 0, 100
  int light2 = map(raw_light2, 0, 1023, 100, 0); // map the value from 0, 1023 to 0, 100


  // read humidity
  float humi  = dht.readHumidity();
  // read temperature as Celsius
  float tempC = dht.readTemperature();
  // read temperature as Fahrenheit
  float tempF = dht.readTemperature(true);

    if (isnan(humi) || isnan(tempC) || isnan(tempF)) {
      Serial.println("Failed to read from DHT sensor!");
    } else {
    Serial.print("Humidity: ");
    Serial.print(humi);
    Serial.print("%");

    Serial.print("  |  "); 

    Serial.print("Temperature: ");
    Serial.print(tempC);
    Serial.print("°C ~ ");
    Serial.print(tempF);
    Serial.println("°F");
  }

  Serial.print("Sensor 1 level: "); 
  Serial.println(light1); // print the light value in Serial Monitor
  Serial.print("Sensor 2 level: "); 
  Serial.println(light2); // print the light value in Serial Monitor
 
  delay(5000); // add a delay to only read and print every 5 second
}

