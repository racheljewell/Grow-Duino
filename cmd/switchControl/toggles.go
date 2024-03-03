package switchcontrol

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

const (
	baseURL         = `https://home.johnstephani.com`
	onEndpointPath  = `/api/services/switch/turn_on`
	offEndpointPath = `/api/services/switch/turn_off`
)

type APIRequest struct {
	EntityID string `json:"entity_id"`
}

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

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("Error reading HTTP response body: %v", err)
	}

	fmt.Println(string(body))
}

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
