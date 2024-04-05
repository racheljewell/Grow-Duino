import datetime

def ToSettings(userID, source):
    s = source.to_dict()
    settings = Settings(
        userID=userID,
        onTime=s.get('lightsOn'),
        offTime=s.get('lightsOff'),
        minHumidity=s.get('minHumidity'),
        maxHumidity=s.get('maxHumidity'),
        minTemp=s.get('minTemp'),
        maxTemp=s.get('maxTemp')
    )
    return settings


class Settings:
    def __init__(self, userID, onTime, offTime, minHumidity, maxHumidity, minTemp, maxTemp):
        self.userID = userID
        self.onTime = datetime.datetime.strptime(onTime, '%H:%M:%S').time()
        self.offTime = datetime.datetime.strptime(offTime, '%H:%M:%S').time()
        self.minHumidity = minHumidity
        self.maxHumidity = maxHumidity
        self.minTemp = minTemp
        self.maxTemp = maxTemp

    def PrettyPrint(self):
        print("Settings for: ", self.userID)
        print("On Time: ", self.onTime)
        print("Off Time: ", self.offTime)
        print("Min Humidity: ", self.minHumidity)
        print("Max Humidity: ", self.maxHumidity)
        print("Min Temp: ", self.minTemp)
        print("Max Temp: ", self.maxTemp)