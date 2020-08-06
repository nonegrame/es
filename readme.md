# elasticsearch with IK

`docker-compose up -d`

先把 elasticsearch 跟 kibana 跑起來

elasticsearch image 已經先安裝好 ikanalytis & 自訂詞庫

如果要修改 elasticsearch image 可以自己改 Dockerfile

## check status

[elasticsearch](http://localhost:9200/)

[kibana](http://localhost:5601)

*kibana 會花比較久的時間啟動*

## example

先到
[kibana dev_tools](http://localhost:5601/app/kibana#/dev_tools)

把下面的 code 貼上去執行

---

建立 index

```js
PUT new-index
{
  
}
```

建立 index 欄位 mapping

```js
POST new-index/_mapping
{
  "properties": {
    "content": {
      "type": "text",
      "analyzer": "ik_max_word",
      "search_analyzer": "ik_smart"
    }
  }
}
```

建立假資料

```js
POST new-index/_doc
{
  "content": """魯蛇，亦有時作滷蛇，是PTT的一個流行用語。

魯蛇即英文「loser」（失敗者）的諧音。由於在ptt上很多酸民喜歡酸其他有成就或過得爽的人（有錢人、公務員、替代役…），反過來就會有些鄉民開始反酸這些人自己是loser（例沒錢、沒工作或領22k、交不到女朋友的阿宅之類），所以只能在網路上酸別人。之後就逐漸出現這個諧音的用法來取代loser一詞。 """
}

POST new-index/_doc
{
  "content": """肥宅一詞並不起源於PTT（K島、巴哈姆特都較ptt早流行），在PTT也並非什麼新的用法，先前在各種討論「宅」、「宅宅」的文章中，也會不時出現。其中在lol版最常出現，而八卦版也有時會出現。鄉民在自嘲很宅的時候，也偶爾會用上「肥宅」一詞。此外，原本就在使用「宅」這一詞的日本，也有相同的用法，即「デブでオタク」（羅馬拼音：Debu De Otaku），意思是「又肥又宅」。 """
}

POST new-index/_doc
{
  "content": """肥宅悲歌 或 XX 悲歌 是 肥宅 鄉民 們 對有關御宅文化或感情路坎坷的理工男的悲劇感同身受而發出的喟嘆， 有時是自嘲，有時是可憐同在八卦板的其它肥宅，感嘆有一天也會淪落到那樣。 例如 中年尼特族心肌梗塞猝死三天後才被鄰居發現 ， 純情竹科男遭酒店小姐吸金百萬 之類的新聞， 常會有 肥宅悲歌 或 肥宅悲歌 QQ 的推文。  """
}
```

實際搜尋

```js
GET new-index/_search
{
  "query": {
    "match": {
      "content": "肥宅"
    }
  },
  "highlight": {
    "fields": {
      "content": {}
    }
  }
}
```

搜尋結果 (擷取部分)

```js
"highlight" : {
    "content" : [
        "<em>肥宅</em>一詞並不起源於PTT（K島、巴哈姆特都較ptt早流行），在PTT也並非什麼新的用法，先前在各種討論「宅」、「宅宅」的文章中，也會不時出現。其中在lol版最常出現，而八卦版也有時會出現。"
    ]
}
```

可以看到`肥宅`已經可以正確的被切出來了

只裝 `ik-analyzer` 肥宅會被切成 `肥` `宅` 而不是`肥宅`

需要更多關鍵字可以去設定 `./dict` 目錄的檔案或自行新增

## 參考資料

[docker-compose-file](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-compose-file)

[elasticsearch-analysis-ik](https://github.com/medcl/elasticsearch-analysis-ik#quick-example)

[切詞檔案來源](https://github.com/samejack/sc-dictionary)
