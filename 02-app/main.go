package main

import (
	"github.com/gin-gonic/gin"
	"github.com/leonrodenburg/alicloud-academy-day/store"
	"net/http"
)

func main() {
	tableStore := store.NewTableStore()

	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"healthy": true})
	})
	r.POST("/", func(c *gin.Context) {
		var record store.Record
		if err := c.ShouldBindJSON(&record); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		err := tableStore.Put(record)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		c.Status(http.StatusNoContent)
	})
	r.GET("/:id", func(c *gin.Context) {
		id := c.Param("id")
		record, err := tableStore.GetById(id)
		if err != nil {
			c.JSON(404, gin.H{
				"error": "Not Found",
			})
			return
		}
		c.JSON(200, record)
	})
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
