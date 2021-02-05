
function nix-args(){
    nix eval -f '<nixpkgs>' --json $1.override 2> /dev/null | sed 's/\,"\w\+":\([,}]\)/\1/g' | jq .__functionArgs
}

_nix-args() {
    if [[ -z ${words[2]} ]]; then
        return
    fi

read -d '' query << EOF
    {
      "from": 0,
      "size": 50,
      "sort": [
        "_score"
      ],
      "_source": [
        "package_attr_name"
      ],
      "query": {
        "bool": {
          "filter": [
            {
              "term": {
                "type": {
                  "value": "package"
                }
              }
            }
          ],
          "must": [
            {
              "dis_max": {
                "tie_breaker": 0.7,
                "queries": [
                  {
                    "multi_match": {
                      "type": "cross_fields",
                      "query": "${words[2]}",
                      "analyzer": "whitespace",
                      "auto_generate_synonyms_phrase_query": false,
                      "operator": "and",
                      "fields": [
                        "package_attr_name^9",
                        "package_attr_name.edge^9",
                        "package_pname^6",
                        "package_pname.edge^6",
                        "package_attr_name_query^4",
                        "package_attr_name_query.edge^4"
                      ]
                    }
                  }
                ]
              }
            }
          ]
        }
      }
    }
EOF

    COMPREPLY=$(curl -s 'https://nixos-search-5886075189.us-east-1.bonsaisearch.net/latest-13-20.09/_search' \
        -H 'authorization: Basic ejNaRko2eTJtUjpkczhDRXZBTFBmOXB1aTdYRw==' \
        -H 'content-type: application/json' \
        --data-binary "$query" \
        --compressed \
        | noglob jq -r .hits.hits[]._source.package_attr_name)


    IFS=$'\n' array_of_lines=("${(@f)$(printf $COMPREPLY)}")
    compadd -d $array_of_lines
}

compdef _nix-args nix-args
