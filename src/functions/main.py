from firebase_functions import https_fn, firestore_fn
from firebase_admin import initialize_app, firestore
# import dotenv
import os
import requests
import logging
from datetime import datetime
from settings import Settings

app = initialize_app()
# dotenv.load_dotenv() 

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@firestore_fn.on_document_updated(document="GrowDuino/settings")
def scheduleLightOn(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
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
    settings = Settings(settingsDict['onTime'], settingsDict['offTime'])
    logger.info(settings.onTime)
    

    if settings.onTime <= now and not settings.offTime <= now:
        logger.info("Time is before now.")
        serviceData = {
            'entity_id': 'switch.switch_a'
        }
        
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_on", headers=headers, json=serviceData)
            response.raise_for_status()  # Raise an exception for HTTP errors
            logger.info("Light on scheduled successfully.")
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to schedule light on: {e}")
   
    if settings.offTime <= now:
        logger.info("Time is before now.")
        serviceData = {
            'entity_id': 'switch.switch_a'
        }
    
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}/api/services/switch/turn_off", headers=headers, json=serviceData)
            response.raise_for_status()  # Raise an exception for HTTP errors
            logger.info("Light off scheduled successfully.")
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to schedule light off: {e}")

    logger.info("End of function.")