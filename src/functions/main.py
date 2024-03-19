from firebase_functions import https_fn, firestore_fn
from firebase_admin import initialize_app, firestore
# import dotenv
import os
import requests
import logging
from datetime import datetime

app = initialize_app()
# dotenv.load_dotenv() 

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@firestore_fn.on_document_updated(document="settings/{setting}")
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
    
    logger.info("event param " + event.params['setting'])
    if event.params['setting'] == 'onTime':
        time_ref = db.collection('settings').document('onTime')
        time_dict = time_ref.get().to_dict()
        time = time_dict['onTime']
        logger.info(time)
        on_time = datetime.strptime(time, '%H:%M:%S').time()
        logger.info(on_time)
        if on_time <= now:
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
    if event.params['setting'] == 'offTime':
        time_ref = db.collection('settings').document('offTime')
        time_dict = time_ref.get().to_dict()
        time = time_dict['offTime']
        logger.info(time)
        off_time = datetime.strptime(time, '%H:%M:%S').time()
        logger.info(off_time)
        if off_time <= now:
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
    # if on_time < 0 or on_time > 23:
    #     return
    
    # # onTime = datetime.strptime(on_time, '%H:%M:%S').time()
    
    
    logger.info("End of function.")