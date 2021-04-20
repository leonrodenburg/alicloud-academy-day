package store

import (
	"fmt"
	"github.com/aliyun/aliyun-tablestore-go-sdk/tablestore"
	"os"
)

type Store interface {
	GetById(id string) (Record, error)
	Put(record Record) error
}

type Record struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type TableStore struct {
	client    *tablestore.TableStoreClient
	tableName string
}

func NewTableStore() Store {
	otsEndpoint := os.Getenv("TABLE_STORE_ENDPOINT")
	otsInstance := os.Getenv("TABLE_STORE_INSTANCE")
	otsTable := os.Getenv("TABLE_STORE_TABLE")
	otsAccessKeyID := os.Getenv("TABLE_STORE_ACCESS_KEY_ID")
	otsAccessKeySecret := os.Getenv("TABLE_STORE_ACCESS_KEY_SECRET")
	client := tablestore.NewClient(otsEndpoint, otsInstance, otsAccessKeyID, otsAccessKeySecret)
	return &TableStore{
		client:    client,
		tableName: otsTable,
	}
}

func (t *TableStore) GetById(id string) (Record, error) {
	getRowRequest := new(tablestore.GetRowRequest)
	criteria := new(tablestore.SingleRowQueryCriteria)
	primaryKey := new(tablestore.PrimaryKey)
	primaryKey.AddPrimaryKeyColumn("id", id)

	criteria.PrimaryKey = primaryKey
	getRowRequest.SingleRowQueryCriteria = criteria
	getRowRequest.SingleRowQueryCriteria.TableName = t.tableName
	getRowRequest.SingleRowQueryCriteria.MaxVersion = 1
	resp, err := t.client.GetRow(getRowRequest)
	if err != nil {
		return Record{}, err
	}

	columnMap := resp.GetColumnMap()
	if len(columnMap.Columns) == 0 {
		return Record{}, fmt.Errorf("record not found")
	}
	name := columnMap.Columns["name"][0]
	return Record{
		ID:   id,
		Name: fmt.Sprintf("%v", name.Value),
	}, nil
}

func (t *TableStore) Put(record Record) error {
	putRowRequest := new(tablestore.PutRowRequest)
	putRowChange := new(tablestore.PutRowChange)
	putRowChange.TableName = t.tableName
	primaryKey := new(tablestore.PrimaryKey)
	primaryKey.AddPrimaryKeyColumn("id", record.ID)

	putRowChange.PrimaryKey = primaryKey
	putRowChange.AddColumn("name", record.Name)
	putRowChange.SetCondition(tablestore.RowExistenceExpectation_IGNORE)
	putRowRequest.PutRowChange = putRowChange
	_, err := t.client.PutRow(putRowRequest)
	return err
}
