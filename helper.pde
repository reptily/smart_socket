#define DEBUG_PRING true

void debug(String message) 
{
  if (DEBUG_PRING == false) {
    return;
  }
  
  Serial.println(message);  
} 

bool StringToBool(String str)
{
  if (str == "true" || str == "True" || str == "TRUE" || str == "1")
  {
    return true;
  }
  
  return false;
}