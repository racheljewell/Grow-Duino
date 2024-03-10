/*
In progres...
*/
package cloudfunctions

import (
	"encoding/json"
	"net/http"
)

func LightsOn(w http.ResponseWriter, r *http.Request) {
	// Parse request body
	var request map[string]interface{}
	err := json.NewDecoder(r.Body).Decode(&request)
	if err != nil {
		http.Error(w, "Failed to parse request body", http.StatusBadRequest)
		return
	}

	// Extract data from request

}
