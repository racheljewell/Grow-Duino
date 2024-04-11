from firebase_functions import https_fn, firestore_fn, scheduler_fn
from firebase_admin import initialize_app, firestore
from .data import userSettings
# import dotenv
import os
import requests
import logging
from datetime import datetime
# dotenv.load_dotenv() 

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@firestore_fn.on_document_created(document="arduino_data/{documentID=**}")
# @firestore_fn.on_document_updated(document="GrowDuino/data")
def evalData(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    if event is None:
        return
    newData = event.data.to_dict()['packet']
    print(newData)
    db = firestore.client()
    apiURL = 'https://home.johnstephani.com'
    homeAssistantToken = os.getenv('ASSISTANT_TOKEN')
    if not homeAssistantToken:
        return
    headers = {
        'Authorization': f'Bearer {homeAssistantToken}',
        'Content-Type': 'application/json'
    }
    lightA = {
            'entity_id': 'switch.switch_a'
    }
    lightB = {
        'entity_id': 'switch.switch_b'
    }
    humidifier = {
        'entity_id': 'switch.switch_c'
    }
    fan = {
        'entity_id': 'switch.switch_d'
    }

    logger.info("Beginning of function.")
    now = datetime.now().time()
    settingsRef = db.collection('settings').document('user1')
    curSettings = userSettings.ToSettings('user1', settingsRef.get())
    logger.info(curSettings.onTime)

    if curSettings.onTime <= now and not curSettings.offTime <= now:
        logger.info("Time is before now.")
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=lightA)
            response.raise_for_status()  # Raise an exception for HTTP errors
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=lightB)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to schedule light on: {e}")
   
    if curSettings.offTime <= now:
        logger.info("Time is before now.")    
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=lightA)
            response.raise_for_status()  # Raise an exception for HTTP errors
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=lightB)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to schedule light off: {e}")

    if curSettings.minHumidity > int(newData['humidity']):
        print("Turn on Humidifier")
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=humidifier)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to turn on humidifier: {e}")

    if curSettings.maxHumidity < int(newData['humidity']):
        print('Turn on fan')
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=fan)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to turn on fan: {e}")

    if curSettings.maxHumidity > int(newData['humidity']) and curSettings.minHumidity < int(newData['humidity']):
        print('Turn off fan and humidifier')
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=fan)
            response.raise_for_status()  # Raise an exception for HTTP errors
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=humidifier)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to turn off fan & humidifier: {e}")

    logger.info("End of function.")

@firestore_fn.on_document_updated(document="settings/user1")
def checkSettingsUpdate(event: firestore_fn.Event[firestore_fn.DocumentSnapshot]) -> None:
    if event is None:
        return
    
    curSettings = userSettings.ToSettings('user1', event.data.after)
    curSettings.PrettyPrint()

    db = firestore.client()
    apiURL = 'https://home.johnstephani.com'
    homeAssistantToken = os.getenv('ASSISTANT_TOKEN')
    if not homeAssistantToken:
        return
    headers = {
        'Authorization': f'Bearer {homeAssistantToken}',
        'Content-Type': 'application/json'
    }
    lightA = {
            'entity_id': 'switch.switch_a'
    }
    lightB = {
        'entity_id': 'switch.switch_b'
    }
    humidifier = {
        'entity_id': 'switch.switch_c'
    }
    fan = {
        'entity_id': 'switch.switch_d'
    }

    logger.info("Beginning of function.")
    now = datetime.now().time()
    dataRef = db.collection('arduino_data').order_by("timestamp").limit(1).get()[0]
    newData = dataRef.to_dict()['packet']
    

    if curSettings.onTime <= now and not curSettings.offTime <= now:
        logger.info("Time is before now.")
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=lightA)
            response.raise_for_status()  # Raise an exception for HTTP errors
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=lightB)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to schedule light on: {e}")
   
    if curSettings.offTime <= now:
        logger.info("Time is before now.")    
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=lightA)
            response.raise_for_status()  # Raise an exception for HTTP errors
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=lightB)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to schedule light off: {e}")

    if curSettings.minHumidity > int(newData['humidity']):
        print("Turn on Humidifier")
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=humidifier)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to turn on humidifier: {e}")

    if curSettings.maxHumidity < int(newData['humidity']):
        print('Turn on fan')
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=fan)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to turn on fan: {e}")

    if curSettings.maxHumidity > int(newData['humidity']) and curSettings.minHumidity < int(newData['humidity']):
        print('Turn off fan and humidifier')
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=fan)
            response.raise_for_status()  # Raise an exception for HTTP errors
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=humidifier)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to turn off fan & humidifier: {e}")

    logger.info("End of function.")
