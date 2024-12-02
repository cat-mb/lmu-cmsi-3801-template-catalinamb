package main

import (
	"log"
	"math/rand"
	"sync"
	"time"
)

func logAction(action ...any) {
	log.Println(action...)
}

func performAction(durationSeconds int, actionDescription ...any) {
	logAction(actionDescription...)
	randomMillis := 500*durationSeconds + rand.Intn(500*durationSeconds)
	time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

type MealOrder struct {
	orderID    int64
	customer   string
	preparedBy string
	reply      chan *MealOrder
}

var currentOrderID int64 = 0
var orderIDMutex sync.Mutex

func generateNextOrderID() int64 {
	orderIDMutex.Lock() 
	defer orderIDMutex.Unlock()
	currentOrderID++
	return currentOrderID
}

func cook(cookName string, waiterOrderQueue chan *MealOrder) {
	logAction(cookName, "starting work")
	for mealOrder := range waiterOrderQueue {
		performAction(10, cookName, "cooking order", mealOrder.orderID, "for", mealOrder.customer)
		mealOrder.preparedBy = cookName
		mealOrder.reply <- mealOrder 
	}
}

func customer(customerName string, waiterOrderQueue chan *MealOrder, wg *sync.WaitGroup) {
	defer wg.Done()
	mealsConsumed := 0

	for mealsConsumed < 5 {
		mealOrder := &MealOrder{
			orderID:  generateNextOrderID(),
			customer: customerName,
			reply:    make(chan *MealOrder, 1),
		}

		logAction(customerName, "placed order", mealOrder.orderID)

		select {
		case waiterOrderQueue <- mealOrder: 
			select {
			case completedMeal := <-mealOrder.reply: 
				performAction(2, customerName, "eating cooked order", completedMeal.orderID, "prepared by", completedMeal.preparedBy)
				mealsConsumed++
			}
		case <-time.After(7 * time.Second): 
			performAction(5, customerName, "waited too long, abandoning order", mealOrder.orderID)
		}
	}
	logAction(customerName, "finished dining and is going home")
}

func main() {
	rand.Seed(time.Now().UnixNano())

	customerNames := []string{"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai"}
	waiterOrderQueue := make(chan *MealOrder, 3) 
	var restaurantWaitGroup sync.WaitGroup

	go cook("Remy", waiterOrderQueue)
	go cook("Colette", waiterOrderQueue)
	go cook("Linguini", waiterOrderQueue)

	for _, name := range customerNames {
		restaurantWaitGroup.Add(1)
		go customer(name, waiterOrderQueue, &restaurantWaitGroup)
	}

	restaurantWaitGroup.Wait()

	logAction("The restaurant is closing for the day")
}
