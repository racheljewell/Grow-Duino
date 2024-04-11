import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore
from dbConnection import establishConnection

import datetime

def pushMockData():
    db = establishConnection()
    userID = 'user1'
    if db is not None:
        # Define mock data
        mock_data = {'lightsOn': '9:00:00', 'lightsOff': '11:00:00', 'minHumidity': 35, 'maxHumidity': 65, 'minTemp': 60, 'maxTemp': 80}

        # Push mock data to Firestore
        
        doc_ref = db.collection('settings').document(userID)
        doc_ref.set(mock_data)
            # print(f"Mock data added with ID: {doc_ref.id}")

pushMockData()
