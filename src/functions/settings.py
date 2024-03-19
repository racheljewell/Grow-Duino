import datetime

class Settings:
    def __init__(self, onTime, offTime):
        self.onTime = datetime.datetime.strptime(onTime, '%H:%M:%S').time()
        self.offTime = datetime.datetime.strptime(offTime, '%H:%M:%S').time()
