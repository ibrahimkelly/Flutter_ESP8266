#include <ESP8266WiFi.h>

const char* ssid = "NETWORK";
const char* password = "Password";
const int ledPin = D4;
WiFiServer server(8080);

void setup() {
  Serial.begin(9600);
  Serial.println("Hello, Serial Monitor!");

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(250);
    Serial.println("Connecting...");
  }

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());


  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  server.begin();
}

void loop() {
  WiFiClient client = server.available();

  if (!client) {
    return;
  }

  Serial.println("New request.");
  if (!client.available()) {
    delay(1);
  }

  String request = client.readStringUntil('\r');
  Serial.println(request);

  bool ledState = false;
  if (request.indexOf("GET /on") != -1) {
    digitalWrite(ledPin, HIGH);
    ledState = true;
  } else if (request.indexOf("GET /off") != -1) {
    digitalWrite(ledPin, LOW);
    ledState = false;
  }

  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: application/json");
  client.println("Connection: close");
  client.println();

  client.print("{\"ledState\":");
  client.print(ledState ? "true" : "false");
  client.println("}");

  delay(1);
  Serial.println("Client disconnected");

  client.stop();
}

