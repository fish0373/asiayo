- 試想已有一組 ELK/EFK 日誌服務集群,而今日有一新服務上線並且串接日誌紀錄,讓開發者
能夠透過 Kibana 進行線上錯誤排查,你/妳會如何將日誌檔內容串接至 ELK/EFK 系統?考
量的細節是什麼?

    1. `A.Server` -> `B.filebeat/fluentd` -> `C.Kafka` -> `D.Logstash` -> `E.Elasticsearch` 
    2. 透過filebeat/fluentd蒐集數據送至Kafka，使用輕量化的Log蒐集工具降低伺服器效能負擔
    3. Kafka可設定多種topic、consumer，可依照不同服務進行topic的分類，若未來Log有其他分析的需求，可利用多consumer的特性，在不變更架構的狀況下提供其他服務界接
    4. 透過Logstash做最後一層的資料過濾，將無效資料剃除，也可以在B和C之間設置