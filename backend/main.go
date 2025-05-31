package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type Property struct {
	ID       int    `json:"id"`
	Title    string `json:"title"`
	Location string `json:"location`
	Price    int    `json:"price"`
}

var listings = []Property{
	{1, "Modern Appartment", "New York", 2000},
	{2, "Cozy Cottage", "Vermont", 1200},
}

func propertiesHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(listings)
}

func main() {
	http.HandleFunc("/api/properties", propertiesHandler)
	fmt.Println("Starting backend on :8080...")
	http.ListenAndServe(":8080", nil)
}
