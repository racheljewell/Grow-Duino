import firebase_admin
from firebase_admin import credentials
from dbConnection import establishConnection
import random
from firebase_admin import initialize_app, firestore
import google.auth

import datetime
app = initialize_app()

def pushMockData():
    google_creds, _ = google.auth.load_credentials_from_dict({
        "type": "service_account",
        "project_id": "grow-duino",
        "private_key_id": "62e114a98c63deafc2ef28cc3e1bda81ab84d65d",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCvcgOc1Ca9wSbI\nixlFGRg8ckx8RDvx/3UcgqMpa53I3QByUlVRMo6M1uqJs6OOHbUf7I2jkSZfLjic\nKcI3VDPS87sq/mq0VfdxLKtGwxQRfwm23cJAjecTlPgGO8cVa1dONEVcKXVoAsUv\nQ1FQBldvdVI04i1dyHlkF6yoCTdytO512EA2Xi9QtVcHb2ZJVZOZiSVwLFkAKnMq\nmcFuj8MUKs3iR+Nj2q2IC3Ds9/H5dmjV1BQlGYM+GFA2+5PQmAkRWRiQWf5yyN+C\njpgtDYfQW73WpNOIP9gq7yXKJR2wLIapKDo0G2JLyWyMH4rbFzB7aiecjlz5KCP/\nU927tAf3AgMBAAECggEADoiv6VO4p+FZEKW+E94DbRJ86Ph2gAXARZRCGi7RLrAc\nMHXgna4SzNkK+E0g4Fq9EL/cb4kZOCsdXNZ0WxGgv20aFSXOLVIUm9QHyYAxaLRw\n8UZHdTVfYXbNFMGD+W+S5AzrFNQizT+zGeC5dJsp4bcpQ1QPTqSwzBln+X2ixPlt\nReScV2A6CsHfXkThp4+Xh+iZOTFyCFiFR5qxm6S1CI0LntgeMpaaHK3eIpSPdaGN\nDMcsyy5VQels3/2/cT9boAo+Rb1+WMsHmSEr2wbwiiV9YC2jgS6L7+DTUiJAsmjR\nUMWhTUd8EcTE6+7jACRklILZ66P2XB+0GWVWPtFvZQKBgQDzCo23DXU5HKLI/D8b\nK5saLdU746E5esxwXxu+gXylboTBZLCTMPUeg0g4o8t8CTF20HdHbVvniAP3qv2U\nhbvn3ofNBcY1HyMxujSzpOZd6+q+BxtgpSy5hMHtHdUQVBnqPB1ON7w5RdDiCgXm\nilfWIV+UBsSmF4c7RkIBA3l6QwKBgQC4zMuncATJOrYCtVzRtWF0Nwf5x5ETzvnK\nQvmpNKq0kWIVV31IXcmRhfkXgxQBT1p8ZUo90Sev7bAsjVIhnF57R8AaNwv8S546\noadjzavb/H9k5Q1icGBnMXz2Xjf5aS9y5gWRAf9sL5wxF15G0FNk9zrnBfUAR+V4\nCTbsOJciPQKBgA3MlplDGVnBx3hT4h1fz3GgEpBQ71F9KGhk7gVWAsa9zKnSVrg0\numYeHBajLiV/vCA729nhWqt9rIP+YGFzamTS3LEGV+eiOfRT1zQv86h3gZ+Cdcp5\n9l0eLYiR/gvsSoBjI2LShUxXK3H6EbWyOyR8Rpn3/GhVw6bY6Vx3XwlTAoGAU1ja\niTv2jKOUL4iIwnRh7b5cNIWTozF4a4blfzEnxKTFbga1lIvoO2AHRllyDl0x3GT6\npQLOOYSkLpPWdR5HZqant6sYFsQsKxl5m4PJfUBWXLUJ4ln4wNILIDrCWBTet52S\n6SHTh4G5mlKFzL5svl7bDBMduvCyR/8v7D5hu6kCgYEAssB8wXaE3HLvdTWCBGAi\nApfJnzJgmfPLG7LbYPZdXxBgeXO6xCWCJ04eiwyqPHHEbv7XwKqU7d4Y7YxJXmFU\nazjUGO8z6vX2KllrZZRSus7B/OQnNVeYrbAz+lGpgY75oBuCFLLDlo/qTDVSjvvS\nmPOj8cYioc1npIqrNxLHJSY=\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-dafan@grow-duino.iam.gserviceaccount.com",
        "client_id": "107524830934348756066",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-dafan%40grow-duino.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
        })

        # Initialize Firestore client with the loaded credentials
    db = firestore.Client(project='grow-duino', credentials=google_creds)
    if db is not None:
        # Define mock data
        year = 2024
        month = 4
        day = 13
        hour = 12
        minute = 0
        second = 0
        temperature = 78.0
        humidity = 57
        lights = 130
        # mock_data = [
        #     {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 0, 0), "packet": {"temperature": 30.0, "humidity": 50.0, "light_sensor1": 100, "light_sensor2": 150}},
        #     {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 1, 0), "packet": {"temperature": 25.5, "humidity": 51.0, "light_sensor1": 101, "light_sensor2": 149}},
        #     {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 2, 0), "packet": {"temperature": 26.0, "humidity": 50.0, "light_sensor1": 100, "light_sensor2": 150}},
        #     {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 0, 0), "packet": {"temperature": 24.0, "humidity": 51.0, "light_sensor1": 101, "light_sensor2": 149}},
        #     {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 1, 0), "packet": {"temperature": 22.0, "humidity": 50.0, "light_sensor1": 100, "light_sensor2": 150}},
        #     {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 2, 0), "packet": {"temperature": 25.5, "humidity": 51.0, "light_sensor1": 101, "light_sensor2": 149}},
        #     {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 3, 0), "packet": {"temperature": 30.3, "humidity": 51.2, "light_sensor1": 100, "light_sensor2": 150}},
        #     {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 4, 0), "packet": {"temperature": 22.5, "humidity": 51.3, "light_sensor1": 101, "light_sensor2": 149}},
        #     {"arduino_id": "arduino1", "timestamp": datetime.datetime(2024, 4, 1, 12, 5, 0), "packet": {"temperature": 22.0, "humidity": 50.7, "light_sensor1": 100, "light_sensor2": 150}},
        #     {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 3, 0), "packet": {"temperature": 21.0, "humidity": 51.0, "light_sensor1": 101, "light_sensor2": 149}},
        #     {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 4, 0), "packet": {"temperature": 27.0, "humidity": 50.0, "light_sensor1": 100, "light_sensor2": 150}},
        #     {"arduino_id": "arduino2", "timestamp": datetime.datetime(2024, 4, 1, 12, 5, 0), "packet": {"temperature": 25.5, "humidity": 48.0, "light_sensor1": 101, "light_sensor2": 149}},
        #     # Add more mock data as needed
        # ]
        mock_data = []

        while hour < 15:
            data = {
                "timestamp": datetime.datetime(year, month, day, hour, minute, second),
                "packet": {
                    "temperature": temperature,
                    "humidity": humidity,
                    "lights": lights
                }
            }
            mock_data.append(data)
            if minute == 59:
                minute = 0
                hour = hour + 1
            else:
                minute = minute + 1

            tempChange = random.uniform(-2,2)
            humidityChange = random.uniform(-2,2)
            lightChange = random.uniform(-2,2)
            temperature = temperature + tempChange
            humidity = humidity + humidityChange
            lights = lights + lightChange

            

        # Push mock data to Firestore
        for data in mock_data:
            doc_ref = db.collection('arduino_data').add(data)
            # print(f"Mock data added with ID: {doc_ref.id}")

pushMockData()
