from firebase_functions import https_fn, options
from firebase_admin import initialize_app, firestore
import logging
import json
from .data import getSettings, userSettings

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@https_fn.on_request(
    cors=options.CorsOptions(cors_origins="*", cors_methods=["post"])
)
def getData(req: https_fn.CallableRequest) -> any:    
    try:
        db = firestore.Client()
        dataRef = db.collection('arduino_data').order_by("timestamp").limit(100).get()
        
        dataList = []
        for data in dataRef:
            dictData = data.to_dict().get('packet')
            if dictData:
                time = data.to_dict().get('timestamp').strftime('%Y-%m-%d %H:%M:%S')
                dataList.append({'data': dictData, 'time': time})
            else:
                logger.warning("Missing 'packet' or 'timestamp' in Firestore document.")
        
        return https_fn.Response(json.dumps({'list': dataList}), content_type="application/json", status=200)
    
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        return https_fn.Response("Internal Server Error", status=500)
    
@https_fn.on_request(
    cors=options.CorsOptions(cors_origins="*", cors_methods=["post"])
)
def getSettings(req: https_fn.CallableRequest) -> any:   
    try:
        db = firestore.Client()
        if db != None:
            settingsRef = db.collection('settings').document('user1')
            curSettings = settingsRef.get().to_dict()
            
        return https_fn.Response(json.dumps({'settings': curSettings}), content_type="application/json", status=200)
    
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        return https_fn.Response("Internal Server Error", status=500)
