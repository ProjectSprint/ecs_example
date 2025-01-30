package main

import (
	"encoding/json"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

type RequestInfo struct {
	Method      string      `json:"method"`
	URL         string      `json:"url"`
	Headers     http.Header `json:"headers"`
	Body        string      `json:"body"`
	QueryParams string      `json:"query_params"`
}

func echoHandler(w http.ResponseWriter, r *http.Request) {
	// Log immediately when a request is received
	log.Printf("Received request: %s %s", r.Method, r.URL.Path)

	// Read the request body
	body, err := io.ReadAll(r.Body)
	if err != nil {
		log.Printf("Error reading body: %v", err)
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
		log.Printf("Error marshaling JSON: %v", err)
		http.Error(w, "Error creating response", http.StatusInternalServerError)
		return
	}

	// Log the response
	log.Printf("Sending response: %s", response)

	// Set response headers
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	// Write response
	_, err = w.Write(response)
	if err != nil {
		log.Printf("Error writing response: %v", err)
	}
}

func main() {
	// Configure logging
	log.SetOutput(os.Stdout)
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)

	// Log environment information
	log.Printf("Starting server with environment:")
	for _, env := range os.Environ() {
		log.Printf("ENV: %s", env)
	}

	// Register handler for all paths
	http.HandleFunc("/", echoHandler)

	// Log server startup
	log.Printf("Server starting on :8080...")

	// Start a goroutine to periodically check if server is running
	go func() {
		ticker := time.NewTicker(10 * time.Second)
		for range ticker.C {
			resp, err := http.Get("http://localhost:8080/healthz")
			if err != nil {
				log.Printf("Self health check failed: %v", err)
			} else {
				resp.Body.Close()
				log.Printf("Self health check succeeded")
			}
		}
	}()

	// Start server
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
