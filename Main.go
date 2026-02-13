package main

import (
	"log"
	"go-task-queue/internal/tasks"
	"github.com/hibiken/asynq"
)

func main() {
	client := asynq.NewClient(asynq.RedisClientOpt{Addr: "localhost:6379"})
	defer client.Close()

	// Create the task object
	task, err := tasks.NewWelcomeEmailTask(101, "hello@example.com")
	if err != nil {
		log.Fatalf("could not create task: %v", err)
	}

	// Enqueue the task
	info, err := client.Enqueue(task)
	if err != nil {
		log.Fatalf("could not enqueue task: %v", err)
	}

	log.Printf("Successfully enqueued task: %s", info.ID)
}
