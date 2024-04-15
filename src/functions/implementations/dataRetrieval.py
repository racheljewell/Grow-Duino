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
        dataRef = db.collection('arduino_data').order_by("timestamp", direction=firestore.Query.DESCENDING).limit(100).get()
        
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
def getRecentData(req: https_fn.CallableRequest) -> any:    
    try:
        db = firestore.Client()
        dataRef = db.collection('arduino_data').order_by("timestamp", direction=firestore.Query.DESCENDING).limit(1).get()[0]
        dictData = dataRef.to_dict().get('packet')
        
        
        return https_fn.Response(json.dumps({'data': dictData}), content_type="application/json", status=200)
    
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
            
        print(curSettings)
        return https_fn.Response(json.dumps({'settings': curSettings}), content_type="application/json", status=200)
    
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        return https_fn.Response("Internal Server Error", status=500)

@https_fn.on_request(
    cors=options.CorsOptions(cors_origins="*", cors_methods=["post"])
)    
def saveSettings(req: https_fn.CallableRequest) -> any: 
    try:
        # Parse the JSON payload from the request
        data = req.get_json()
        print("DATA!")
        print(data)

        # Connect to Firestore
        db = firestore.Client()

        # Check if the database connection is successful
        if db is not None:
            # Reference the 'settings' collection and the document 'user1'
            settingsRef = db.collection('settings').document('user1')
            
            # Save the settings data to Firestore
            settingsRef.set(data)

            # Return a success response
            return {'message': 'Settings saved successfully'}, 200
        else:
            # Return an error response if the database connection is not established
            return {'error': 'Failed to connect to Firestore'}, 500

    except Exception as e:
        # Log any unexpected errors
        print(f"An unexpected error occurred: {e}")
        return {'error': 'Internal Server Error'}, 500
