# example01

synonym

精神撫慰金 => 精神慰撫金

```js
GET test-index/_search
{
  "query": {
    "query_string": {
      "query": "精神慰撫金"
    }
  },
  "sort": [
    {

      "_score": {
        "order": "desc"
      }
    }
  ],
  "size": 20,
  "highlight": {
    "pre_tags": [
      "<tag1>"
    ],
    "post_tags": [
      "</tag1>"
    ],
    "fields": {
      "JFULL": {}
    }
  }
}


GET test-index/_search
{
  "query": {
    "match": {
      "JFULL": "精神慰撫金"
    }
  }
}


# create index & apply analyzer
PUT test-index
{
  "mappings": {
    "properties": {
      "JFULL": {
        "type": "text",
        "analyzer": "ik_max_word",
        "search_analyzer": "ik_smart"
      }
    }
  }
}

# check synonym
POST /test-index/_analyze
{
    "text": "精神撫慰金",
    "analyzer": "ik_max_word"
}


# create index & apply synonym
PUT test-index/
{
  "mappings": {
    "properties": {
      "JFULL": {
        "analyzer": "ik_syno_max",
        "search_analyzer": "ik_syno_smart",
        "type": "text"
      }
    }
  },
  "settings": {
    "analysis": {
      "analyzer": {
        "ik_syno_smart": {
          "type": "custom",
          "tokenizer": "ik_smart",
          "filter": ["my_synonym"]
        },
        "ik_syno_max": {
          "type": "custom",
          "tokenizer": "ik_max_word",
          "filter": ["my_synonym"]
        }
      },
      "filter": {
        "my_synonym": {
          "type": "synonym",
          "synonyms_path": "analysis/synonym.txt"
        }
      }
    }
  }
}

# check synonym
POST /test-index/_analyze
{
    "text": "精神撫慰金",
    "analyzer": "ik_syno_max"
}



PUT /test-index/_mapping
{
  "properties": {
    "JDATE": {
      "type": "integer"
    },
    "JYEAR": {
      "type": "integer"
    }

  }
}

GET test-index/_mapping
{
  
}

# insert test data
POST test-index/_doc
{
  "JFULL": "我要 精神撫慰金 !! 請給我木材"
}

POST test-index/_doc
{
  "JFULL": "我要 精神慰撫金 !! 請給我石頭"
}

# delete index
DELETE test-index
{
  
}
```
