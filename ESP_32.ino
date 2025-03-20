/* -----------------------------------------------------------------------------
  - Project: Biometric Attendance System using ESP32
  - Description: Uses a fingerprint sensor to log attendance.
  - Author: Electronics Tech Channel
  - Date: 29/02/2020
   ---------------------------------------------------------------------------*/

//******************************* Libraries ********************************
#include <WiFi.h>
#include <HTTPClient.h>
#include <SimpleTimer.h>
#include <Adafruit_Fingerprint.h>

//******************************* Fingerprint Sensor Pins ********************************
const byte rxPin = 18; // GPIO18 for RX
const byte txPin = 17; // GPIO17 for TX
const int relayPin = 5; // GPIO5 for controlling the relay
HardwareSerial fserial(1); // Use UART1 for Fingerprint Sensor
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&fserial);

//******************************* WiFi Credentials ********************************
const char *ssid = "LAPTOP-1DANAA2Q8309";
const char *password = "12345678";
const char* device_token  = "028ec80c";
String getData, Link;
String URL = "http://192.168.137.1/biometricattendancev2/getdata.php";

//******************************* Globals ********************************
SimpleTimer timer;
int FingerID = 0;
int t1, t2,id;
bool device_Mode = false;
bool firstConnect = false;
unsigned long previousMillis = 0;

//******************************* LED and Buzzer Pins ********************************
const int redLedPin = 26;
const int greenLedPin = 27;
const int buzzerPin = 14;

//******************************* Setup ********************************
void setup() {
  Serial.begin(115200); // Debug Serial
  delay(1000);

  // Initialize hardware serial for fingerprint sensor
  fserial.begin(57600, SERIAL_8N1, rxPin, txPin); // Set up UART1 with RX/TX pins
  Serial.println("Initializing Fingerprint Sensor...");

  // Check if the fingerprint sensor is detected
  if (finger.verifyPassword()) {
    Serial.println("Fingerprint sensor detected!");
  } else {
    Serial.println("Failed to find fingerprint sensor.");
    while (true) {
      delay(1); // Halt execution
    }
  }

  finger.getTemplateCount();
  Serial.print("Sensor contains "); Serial.print(finger.templateCount); Serial.println(" templates");
  Serial.println("Waiting for valid finger...");

  // Initialize LEDs and buzzer pins
  pinMode(redLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);
  pinMode(buzzerPin, OUTPUT);

  // Turn off LEDs initially
  digitalWrite(redLedPin, LOW);
  digitalWrite(greenLedPin, LOW);


  //Timers---------------------------------------
  timer.setInterval(25000L, CheckMode);
  t1 = timer.setInterval(10000L, ChecktoAddID);      //Set an internal timer every 10sec to check if there a new fingerprint in the website to add it.
  t2 = timer.setInterval(15000L, ChecktoDeleteID);   //Set an internal timer every 15sec to check wheater there an ID to delete in the website.
  //---------------------------------------------

  pinMode(relayPin, OUTPUT);
digitalWrite(relayPin, HIGH); // Ensure the relay is initially off

  CheckMode();
}
//************************************************************************
void loop() {
  timer.run();      //Keep the timer in the loop function in order to update the time as soon as possible
  //check if there's a connection to Wi-Fi or not
  if(!WiFi.isConnected()){
    if (millis() - previousMillis >= 10000) {
      previousMillis = millis();
      connectToWiFi();    //Retry to connect to Wi-Fi
    }
  }
  CheckFingerprint();   //Check the sensor if the there a finger.
  delay(10);
}
//************************************************************************
void CheckFingerprint(){
//  unsigned long previousMillisM = millis();
//  Serial.println(previousMillisM);
  // If there no fingerprint has been scanned return -1 or -2 if there an error or 0 if there nothing, The ID start form 1 to 127
  // Get the Fingerprint ID from the Scanner
  FingerID = getFingerprintID();
  DisplayFingerprintID();
//  Serial.println(millis() - previousMillisM);
  
}
//*Display the fingerprint ID state on the OLED************
void DisplayFingerprintID() {
  if (FingerID > 0) {
    turnOnGreenLED();
    buzzerBeep(200); // Short beep for a match
    SendFingerprintID(FingerID); // Send the Fingerprint ID to the website

    // Unlock the door
    Serial.println("Door unlocked");
    digitalWrite(relayPin, LOW); // Turn on the relay to unlock the door
    delay(3000); // Keep the door unlocked for 2 seconds
    digitalWrite(relayPin, HIGH); // Turn off the relay to lock the door again
    Serial.println("Door locked");
  } 
  else if (FingerID == 0) {
    // No finger detected
  } 
  else if (FingerID == -1) {
    Serial.println("fingerprint didn't match.");
    Serial.println("Door locked");
    turnOnRedLED(); // Turn on red LED
    buzzerBeep(800); // Long beep for no match   
  } 
  else if (FingerID == -2) {
    turnOnRedLED(); // Turn on red LED
  }
}
//*send the fingerprint ID to the website************
void SendFingerprintID( int finger ){
  Serial.println("Sending the Fingerprint ID");
  if(WiFi.isConnected()){
    HTTPClient http;    //Declare object of class HTTPClient
    //GET Data
    getData = "?FingerID=" + String(finger) + "&device_token=" + String(device_token); // Add the Fingerprint ID to the Post array in order to send it
    
    //GET methode
    Link = URL + getData;
    http.begin(Link); //initiate HTTP request   //Specify content-type header
    
    int httpCode = http.GET();   //Send the request
    String payload = http.getString();    //Get the response payload
    
    Serial.println(httpCode);   //Print HTTP return code
    Serial.println(payload);    //Print request response payload
    Serial.println(finger);     //Print fingerprint ID
  
    if (payload.substring(0, 5) == "login") {
      String user_name = payload.substring(5);
    Serial.println(user_name);
    turnOnGreenLED(); // Turn on green LED for successful login
    }
    else if (payload.substring(0, 6) == "logout") {
      String user_name = payload.substring(6);
    Serial.println(user_name);
    turnOnGreenLED(); // Turn on green LED for successful logout
    } else {
      turnOnRedLED(); // Turn on red LED if there is an error
    }
    delay(10);
    http.end();  //Close connection
  }
}
//*Get the Fingerprint ID*****************
int  getFingerprintID() {
  uint8_t p = finger.getImage();
  switch (p) {
    case FINGERPRINT_OK:
      //Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      //Serial.println("No finger detected");
      return 0;
    case FINGERPRINT_PACKETRECIEVEERR:
      //Serial.println("Communication error");
      return -2;
    case FINGERPRINT_IMAGEFAIL:
      //Serial.println("Imaging error");
      return -2;
    default:
      //Serial.println("Unknown error");
      return -2;
  }
  // OK success!
  p = finger.image2Tz();
  switch (p) {
    case FINGERPRINT_OK:
      //Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      //Serial.println("Image too messy");
      return -1;
    case FINGERPRINT_PACKETRECIEVEERR:
      //Serial.println("Communication error");
      return -2;
    case FINGERPRINT_FEATUREFAIL:
      //Serial.println("Could not find fingerprint features");
      return -2;
    case FINGERPRINT_INVALIDIMAGE:
      //Serial.println("Could not find fingerprint features");
      return -2;
    default:
      //Serial.println("Unknown error");
      return -2;
  }
  // OK converted!
  p = finger.fingerFastSearch();
  if (p == FINGERPRINT_OK) {
    //Serial.println("Found a print match!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    //Serial.println("Communication error");
    return -2;
  } else if (p == FINGERPRINT_NOTFOUND) {
    //Serial.println("Did not find a match");
    return -1;
  } else {
    //Serial.println("Unknown error");
    return -2;
  }   
  // found a match!
  Serial.print("Found ID #"); Serial.print(finger.fingerID); 
  Serial.print(" with confidence of "); Serial.println(finger.confidence); 

  return finger.fingerID;
}
//*Check if there a Fingerprint ID to delete*****************
void ChecktoDeleteID(){
  Serial.println("Check to Delete ID");
  if(WiFi.isConnected()){
    HTTPClient http;    //Declare object of class HTTPClient
    //GET Data
    getData = "?DeleteID=check&device_token=" + String(device_token); // Add the Fingerprint ID to the Post array in order to send it
    //GET methode
    Link = URL + getData;
    http.begin(Link); //initiate HTTP request,
//    Serial.println(Link);
    int httpCode = http.GET();   //Send the request
    String payload = http.getString();    //Get the response payload
  
    if (payload.substring(0, 6) == "del-id") {
      String del_id = payload.substring(6);
      Serial.println(del_id);
      http.end();  //Close connection
      deleteFingerprint( del_id.toInt() );
      delay(1000);
    }
    http.end();  //Close connection
  }
}
//*Delete Finpgerprint ID****************
uint8_t deleteFingerprint( int id) {
  uint8_t p = -1;
  
  p = finger.deleteModel(id);

  if (p == FINGERPRINT_OK) {
    Serial.println("Deleted!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_BADLOCATION) {
    Serial.println("Could not delete in that location");
    return p;
  } else if (p == FINGERPRINT_FLASHERR) {
    Serial.println("Error writing to flash");
    return p;
  } else {
    Serial.print("Unknown error: 0x"); Serial.println(p, HEX);

    return p;
  }   
}
//*Check if there a Fingerprint ID to add*****************
void ChecktoAddID(){
//  Serial.println("Check to Add ID");
  if(WiFi.isConnected()){
    HTTPClient http;    //Declare object of class HTTPClient
    //GET Data
    getData = "?Get_Fingerid=get_id&device_token=" + String(device_token); // Add the Fingerprint ID to the Post array in order to send it
    //GET methode
    Link = URL + getData;
    http.begin(Link); //initiate HTTP request,
//    Serial.println(Link);
    int httpCode = http.GET();   //Send the request
    String payload = http.getString();    //Get the response payload
  
    if (payload.substring(0, 6) == "add-id") {
      String add_id = payload.substring(6);
      Serial.println(add_id);
      id = add_id.toInt();
      http.end();  //Close connection
      getFingerprintEnroll();
    }
    http.end();  //Close connection
  }
}
//*Check the Mode****************
void CheckMode(){
  Serial.println("Check Mode");
  if(WiFi.isConnected()){
    HTTPClient http;    //Declare object of class HTTPClient
    //GET Data
    getData = "?Check_mode=get_mode&device_token=" + String(device_token); // Add the Fingerprint ID to the Post array in order to send it
    //GET methode
    Link = URL + getData;
    http.begin(Link); //initiate HTTP request,
//    Serial.println(Link);
    int httpCode = http.GET();   //Send the request
    String payload = http.getString();    //Get the response payload
  
    if (payload.substring(0, 4) == "mode") {
      String dev_mode = payload.substring(4);
      int devMode = dev_mode.toInt();
      if(!firstConnect){
        device_Mode = devMode;
        firstConnect = true;
      }
//      Serial.println(dev_mode);
      if(device_Mode && devMode){
        device_Mode = false;
        timer.disable(t1);
        timer.disable(t2);
        Serial.println("Deivce Mode: Attandance");
      }
      else if(!device_Mode && !devMode){
        device_Mode = true;
        timer.enable(t1);
        timer.enable(t2);
        Serial.println("Deivce Mode: Enrollment");
      }
      http.end();  //Close connection
    }
    http.end();  //Close connection
  }
//  Serial.print("Number of Timers: ");
//  Serial.println(timer.getNumTimers());
}
//*Enroll a Finpgerprint ID****************
uint8_t getFingerprintEnroll() {
  int p = -1;

  while (p != FINGERPRINT_OK) {
      
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.println("scanning");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      break;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      break;
    default:
      Serial.println("Unknown error");
      break;
    }
  }
  
  // OK success!
  p = finger.image2Tz(1);
  switch (p) {
    case FINGERPRINT_OK:
      break;
    case FINGERPRINT_IMAGEMESS:
      
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }
  Serial.println("Remove finger");
  delay(2000);
  p = 0;
  while (p != FINGERPRINT_NOFINGER) {
    p = finger.getImage();
  }
  Serial.print("ID "); Serial.println(id);
  p = -1;

  while (p != FINGERPRINT_OK) {
    
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");

      break;
    case FINGERPRINT_NOFINGER:
      Serial.println("scanning");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      break;
    default:
      Serial.println("Unknown error");
      break;
    }
  }

  // OK success!

  p = finger.image2Tz(2);
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");

      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");

      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }
  
  // OK converted!
  Serial.print("Creating model for #");  Serial.println(id);
  
  p = finger.createModel();
  if (p == FINGERPRINT_OK) {
    Serial.println("Prints matched!");

  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
      Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_ENROLLMISMATCH) {
      Serial.println("Fingerprints did not match");

    return p;
  } else {
      Serial.println("Unknown error");
    return p;
  }   
  
  Serial.print("ID "); Serial.println(id);
  p = finger.storeModel(id);
  if (p == FINGERPRINT_OK) {
    Serial.println("Stored!");

    confirmAdding(id);
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_BADLOCATION) {
    Serial.println("Could not store in that location");
    return p;
  } else if (p == FINGERPRINT_FLASHERR) {
    Serial.println("Error writing to flash");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }   
}
//*Check if there a Fingerprint ID to add*****************
void confirmAdding(int id){
  Serial.println("confirm Adding");
  if(WiFi.status() == WL_CONNECTED){
    HTTPClient http;    //Declare object of class HTTPClient
    //GET Data
    getData = "?confirm_id=" + String(id) + "&device_token=" + String(device_token); // Add the Fingerprint ID to the Post array in order to send it
    //GET methode
    Link = URL + getData;
    
    http.begin(Link); //initiate HTTP request,
//    Serial.println(Link);
    int httpCode = http.GET();   //Send the request
    String payload = http.getString();    //Get the response payload
    if(httpCode == 200){

      Serial.println(payload);
      delay(2000);
    }
    else{
      Serial.println("Error Confirm!!");      
    }
    http.end();  //Close connection
  }
}
//*connect to the WiFi*****************
void connectToWiFi(){
    WiFi.mode(WIFI_OFF);        //Prevents reconnection issue (taking too long to connect)
    delay(1000);
    WiFi.mode(WIFI_STA);
    Serial.print("Connecting to ");
    Serial.println(ssid);
    WiFi.begin(ssid, password);

    
    uint32_t periodToConnect = 30000L;
    for(uint32_t StartToConnect = millis(); (millis()-StartToConnect) < periodToConnect;){
      if ( WiFi.status() != WL_CONNECTED ){
        delay(500);
        Serial.print(".");
      } else{
        break;
      }
    }
    
    if(WiFi.isConnected()){
      Serial.println("");
      Serial.println("Connected");

      
      Serial.print("IP address: ");
      Serial.println(WiFi.localIP());  //IP address assigned to your ESP
    }
    else{
      Serial.println("");
      Serial.println("Not Connected");
      WiFi.mode(WIFI_OFF);
      delay(1000);
    }
    delay(1000);
}

//************ Turn on the green LED *************
void turnOnGreenLED() {
  digitalWrite(greenLedPin, HIGH);
  delay(1000); // Keep the green LED on for 1 second
  digitalWrite(greenLedPin, LOW);
}
//************ Turn on the red LED *************
void turnOnRedLED() {
  digitalWrite(redLedPin, HIGH);
  delay(1000); // Keep the red LED on for 1 second
  digitalWrite(redLedPin, LOW);
}
//************ Beep the buzzer *************
void buzzerBeep(int duration) {
  digitalWrite(buzzerPin, HIGH);
  delay(duration); // Beep duration
  digitalWrite(buzzerPin, LOW);
}
//=======================================================================
