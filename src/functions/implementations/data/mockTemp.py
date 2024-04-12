import firebase_admin
from firebase_admin import credentials
from google.cloud import firestore
from dbConnection import establishConnection

import datetime

def pushMockData():
    db = establishConnection()
    if db is not None:
        # Define mock data
        mock_data = [
            {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 0, 0), "packet": {"temperature": 30.0, "humidity": 50.0, "light_sensor1": 100, "light_sensor2": 150}},
            {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 1, 0), "packet": {"temperature": 25.5, "humidity": 51.0, "light_sensor1": 101, "light_sensor2": 149}},
            {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 2, 0), "packet": {"temperature": 26.0, "humidity": 50.0, "light_sensor1": 100, "light_sensor2": 150}},
            {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 0, 0), "packet": {"temperature": 24.0, "humidity": 51.0, "light_sensor1": 101, "light_sensor2": 149}},
            {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 1, 0), "packet": {"temperature": 22.0, "humidity": 50.0, "light_sensor1": 100, "light_sensor2": 150}},
            {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 2, 0), "packet": {"temperature": 25.5, "humidity": 51.0, "light_sensor1": 101, "light_sensor2": 149}},
            {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 3, 0), "packet": {"temperature": 30.3, "humidity": 51.2, "light_sensor1": 100, "light_sensor2": 150}},
            {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 4, 0), "packet": {"temperature": 22.5, "humidity": 51.3, "light_sensor1": 101, "light_sensor2": 149}},
            {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 5, 0), "packet": {"temperature": 22.0, "humidity": 50.7, "light_sensor1": 100, "light_sensor2": 150}},
            {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 3, 0), "packet": {"temperature": 21.0, "humidity": 51.0, "light_sensor1": 101, "light_sensor2": 149}},
            {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 4, 0), "packet": {"temperature": 27.0, "humidity": 50.0, "light_sensor1": 100, "light_sensor2": 150}},
            {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 5, 0), "packet": {"temperature": 25.5, "humidity": 48.0, "light_sensor1": 101, "light_sensor2": 149}},
            # Add more mock data as needed
        ]

        # Push mock data to Firestore
        for data in mock_data:
            doc_ref = db.collection('arduino_data').add(data)
            # print(f"Mock data added with ID: {doc_ref.id}")

pushMockData()
