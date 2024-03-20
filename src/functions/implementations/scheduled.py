from firebase_functions import https_fn, firestore_fn
from firebase_admin import initialize_app, firestore
from dotenv import load_dotenv, find_dotenv
import os
import requests
import logging
from datetime import datetime

app = initialize_app()
load_dotenv() 

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@firestore_fn.on_document_updated(document="settings/{on_time}")
def scheduleLightOn(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:

    logger.info("Beginning of function.")
    if event is None or not event.exists:
        return
    data = event.data()
    on_time = data.get('on_time')
    if not on_time or on_time < 0 or on_time > 23:
        return
    apiURL = 'http://your-homeassistant-ip:8123/api/'
    homeAssistantToken = os.getenv('ASSISTANT_TOKEN')
    if not homeAssistantToken:
        return
    headers = {
        'Authorization': f'Bearer {homeAssistantToken}',
        'Content-Type': 'application/json'
    }
    onTime = datetime.strptime(on_time, '%H:%M:%S').time()
    now = datetime.datetime.now().time
    if on_time <= now:
        logger.info("Time is before now.")
        serviceData = {
            'entity_id': 'switch.switch_a'
        }
    
        try:
            # Send HTTP POST request to Home Assistant API to turn on the light
            response = requests.post(f"{apiURL}services/switch/turn_on", headers=headers, json=serviceData)
            response.raise_for_status()  # Raise an exception for HTTP errors
            logger.info("Light on scheduled successfully.")
        except requests.RequestException as e:
            # Handle HTTP request errors
            print(f"Failed to schedule light on: {e}")
    logger.info("End of function.")