from firebase_admin import credentials
from google.cloud import firestore
from .dbConnection import establishConnection
from google.cloud.firestore_v1.base_query import FieldFilter
from . import userSettings

import datetime

def getSettings(userID):
    db = establishConnection()
    if db != None:
        s = db.collection('settings').document(userID).get()                

        setting = userSettings.ToSettings(userID,s)
        
        return setting

# getSettings("user1").PrettyPrint()