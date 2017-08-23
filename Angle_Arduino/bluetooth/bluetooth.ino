// screen /dev/tty.HC-06-DevB

String message; //string that stores the incoming message

void setup()
{
  Serial.begin(9600); //set baud rate
}

void loop()
{
  Serial.println("Heeelo 11246"); //show the data
  delay(500);
}
    
void test()
{
  while(Serial.available())
  {//while there is data available on the serial monitor
    message+=char(Serial.read());//store string from serial command
  }
  if(!Serial.available())
  {
    if(message!="")
    {//if data is available
      Serial.println(message); //show the data
      message=""; //clear the data
    }
  }
  delay(5000); //delay
}
