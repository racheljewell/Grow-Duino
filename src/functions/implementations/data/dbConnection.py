from firebase_admin import credentials
from google.cloud import firestore
import google.auth

import google.auth
from google.cloud import firestore

def establishConnection():
    # Set your Firestore project ID
    projectID = 'grow-duino'

    try:
        # Load credentials from the service account JSON file
        google_creds, _ = google.auth.load_credentials_from_file('src\data\grow-duino-firebase-adminsdk-dafan-62e114a98c.json')

        # Initialize Firestore client with the loaded credentials
        db = firestore.Client(project=projectID, credentials=google_creds)
        print("Connection to Firestore established successfully.")
        return db
    except Exception as e:
        print(f"Failed to establish connection to Firestore: {e}")
        return None
