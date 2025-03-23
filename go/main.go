package main

import (
	"fmt"

	"github.com/google/uuid"
)

func main() {
	// Generate a new UUID
	newUUID := uuid.New()
	fmt.Println("Generated UUID:", newUUID.String())
}
