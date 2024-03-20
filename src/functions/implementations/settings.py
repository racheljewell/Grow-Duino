from firebase_functions import https_fn, firestore_fn, scheduler_fn
from firebase_admin import initialize_app, firestore
# import dotenv
import os
import requests
import logging
from datetime import datetime


class Settings:
    def __init__(self, onTime, offTime):
        self.onTime =datetime.strptime(onTime, '%H:%M:%S').time()
        self.offTime = datetime.strptime(offTime, '%H:%M:%S').time()

app = initialize_app()
# dotenv.load_dotenv() 

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@firestore_fn.on_document_updated(document="GrowDuino/settings")
def changedSettings(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    if event is None:
        return
    db = firestore.client()
    apiURL = 'https://home.johnstephani.com'
    homeAssistantToken = os.getenv('ASSISTANT_TOKEN')
    if not homeAssistantToken:
        return
    headers = {
        'Authorization': f'Bearer {homeAssistantToken}',
        'Content-Type': 'application/json'
    }

    logger.info("Beginning of function.")
    now = datetime.now().time()
    settingsRef = db.collection('GrowDuino').document('settings')
    settingsDict = settingsRef.get().to_dict()
    curSettings = Settings(settingsDict['onTime'], settingsDict['offTime'])
    logger.info(curSettings.onTime)
    

    if curSettings.onTime <= now and not curSettings.offTime <= now:
        logger.info("Time is before now.")
        lightA = {
            'entity_id': 'switch.switch_a'
        }
        lightB = {
            'entity_id': 'switch.switch_b'
        }
        
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
        lightA = {
            'entity_id': 'switch.switch_a'
        }
        lightB = {
            'entity_id': 'switch.switch_b'
        }
    
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=lightA)
            response.raise_for_status()  # Raise an exception for HTTP errors
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=lightB)
            response.raise_for_status()  # Raise an exception for HTTP errors
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to schedule light off: {e}")

    logger.info("End of function.")
