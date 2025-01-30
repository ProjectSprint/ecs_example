package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

type RequestInfo struct {
	Method      string      `json:"method"`
	URL         string      `json:"url"`
	Headers     http.Header `json:"headers"`
	Body        string      `json:"body"`
	QueryParams string      `json:"query_params"`
}

func echoHandler(w http.ResponseWriter, r *http.Request) {
	// Read the request body
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "Error reading request body", http.StatusInternalServerError)
		return
	}
	defer r.Body.Close()

	// Create request info struct
	requestInfo := RequestInfo{
		Method:  r.Method,
		URL:     r.URL.Path,
		Headers: r.Header,
		Body:    string(body),
	}

	// Convert to JSON
	response, err := json.MarshalIndent(requestInfo, "", "  ")
	if err != nil {
		http.Error(w, "Error creating response", http.StatusInternalServerError)

		return
	}

	// Set response headers
	w.Header().Set("Content-Type", "application/json")

	w.WriteHeader(http.StatusOK)

	// Write response
	fmt.Fprintf(w, "%s", response)

	// Log the response
	fmt.Printf("%s", response)
}

func main() {
	// Register handler for all paths
	http.HandleFunc("/", echoHandler)

	// Start server
	fmt.Println("Server starting on :8080...")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
