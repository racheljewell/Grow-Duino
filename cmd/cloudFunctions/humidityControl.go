package cloudFuctions

import (
	"context"
	"log"

	"cloud.google.com/go/firestore"
)

// HumidityEvent is the payload of a Firestore event containing humidity data.
type HumidityEvent struct {
	Value              float64 `json:"value"`
	TimeAboveThreshold float64 `json:"timeabovethreshold"`
}

// OnHumidityUpdate is triggered by a change to the humidity value in Firestore.
func OnHumidityUpdate(ctx context.Context, e HumidityEvent) error {
	log.Println("Function triggered by humidity update")

	// Retrieve the humidity threshold from environment variables or constants
	// For demonstration purposes, assuming the threshold is 50%
	threshold := 50.0

	// Check if the humidity value is above the threshold
	if e.Value > threshold {
		// Write the "time above threshold" value back to Firestore
		err := writeTimeAboveThreshold(ctx, e.TimeAboveThreshold)
		if err != nil {
			return err
		}
	}

	return nil
}

// writeTimeAboveThreshold writes a value indicating the time above threshold to Firestore.
func writeTimeAboveThreshold(ctx context.Context, currentTime float64) error {
	// Initialize Firestore client
	client, err := firestore.NewClient(ctx, "grow-duino")
	if err != nil {
		return err
	}
	defer client.Close()

	// Reference to the Firestore document where you want to write the "time above threshold"
	docRef := client.Collection("Plant Parent").Doc("Plant Room")

	// Update the document with the "time above threshold" value
	newTime := currentTime + 1
	_, err = docRef.Set(ctx, map[string]interface{}{
		"timeAboveThreshold": newTime, // Assuming you want to timestamp the time
	}, firestore.MergeAll)

	return err
}
