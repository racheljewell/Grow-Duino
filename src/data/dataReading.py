from firebase_admin import credentials
from google.cloud import firestore
from dbConnection import establishConnection
from google.cloud.firestore_v1.base_query import FieldFilter
from dataPacket import ToPacket, plot_sensor_data

import datetime

# startTime and endTime are expected to be datetime objects
def getData(startTime, endTime):
    db = establishConnection()
    if db != None:
        arduinoData = db.collection('arduino_data') \
                        .where(filter=FieldFilter('timestamp', '>', startTime))  \
                        .where(filter=FieldFilter('timestamp', '<', endTime))  \
                        .get()                

        packets = []
        for data in arduinoData:
            packet = ToPacket(data)
            packets.append(packet)
        
        return packets
    
packets = getData(datetime.datetime(2024, 4, 1, 12, 0, 0), datetime.datetime(2024, 4, 1, 12, 6, 0))
plot_sensor_data(packets)


