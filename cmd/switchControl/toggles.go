/*
switchControl

	This package is responsible for making an API call to HomeAssistant to
	turn Kasa Smart Outlets on and off.
*/
package switchcontrol

import (
	"bytes"
	"encoding/json"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

/*
Defining base URL and enpoint paths
*/
const (
	baseURL         = `https://home.johnstephani.com`
	onEndpointPath  = `/api/services/switch/turn_on`
	offEndpointPath = `/api/services/switch/turn_off`
)

/*
Defining the APIRequest Struct
*/
type APIRequest struct {
	EntityID string `json:"entity_id"`
}

/*
ToggleOn

	Takes a deviceID string as a parameter and makes an API request
	to toggle the designated outlet on.
*/
func ToggleOn(deviceID string) {
	err := godotenv.Load()
	if err != nil {
		log.Fatalf("Error loading .env file: %v", err)
	}

	apiToken := os.Getenv("TOKEN")

	reqBody, err := json.Marshal(APIRequest{EntityID: deviceID})
	if err != nil {
		log.Fatalf("Error marshaling JSON request body: %v", err)
	}

	req, err := http.NewRequest("POST", baseURL+onEndpointPath, bytes.NewBuffer(reqBody))
	if err != nil {
		log.Fatalf("Error creating HTTP request: %v", err)
	}

	req.Header.Set("Authorization", "Bearer "+apiToken)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}

	resp, err := client.Do(req)
	if err != nil {
		log.Fatalf("Error sending HTTP request: %v", err)
	}
	defer resp.Body.Close()

	_, err = io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("Error reading HTTP response body: %v", err)
	}

}

/*
ToggleOff

	Takes a deviceID string as a parameter and makes an API request
	to toggle the designated outlet off.
*/
func ToggleOff(deviceID string) {
	err := godotenv.Load()
	if err != nil {
		log.Fatalf("Error loading .env file: %v", err)
	}

	apiToken := os.Getenv("TOKEN")

	reqBody, err := json.Marshal(APIRequest{EntityID: deviceID})
	if err != nil {
		log.Fatalf("Error marshaling JSON request body: %v", err)
	}

	req, err := http.NewRequest("POST", baseURL+offEndpointPath, bytes.NewBuffer(reqBody))
	if err != nil {
		log.Fatalf("Error creating HTTP request: %v", err)
	}

	req.Header.Set("Authorization", "Bearer "+apiToken)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}

	resp, err := client.Do(req)
	if err != nil {
		log.Fatalf("Error sending HTTP request: %v", err)
	}
	defer resp.Body.Close()

	_, err = io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("Error reading HTTP response body: %v", err)
	}

}
