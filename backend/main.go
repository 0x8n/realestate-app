package main

import("fmt"
 "net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request){
	fmt.Fprintf(w, "Hello from Real Estate Backend ApI!")
}

func main(){
	http.HandleFunc("/api/hello", helloHandler)
	fmt.Println("Starting server on :8080...")
	http.ListenAndServe(":8080", nil)
}