if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

function nix-args(){
    nix eval -f '<nixpkgs>' --json $1.override | sed 's/\,"\w\+":\([,}]\)/\1/g' | jq .__functionArgs
}

_nix-args() {

read -d '' query << EOF
    {
      "from": 0,
      "size": 20,
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
                      "query": "jdk",
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

    COMPREPLY=$(curl -s 'https://nixos-search-5886075189.us-east-1.bonsaisearch.net/latest-13-unstable/_search' \
        -H 'authorization: Basic ejNaRko2eTJtUjpkczhDRXZBTFBmOXB1aTdYRw==' \
        -H 'content-type: application/json' \
        --data-binary "$query" \
        --compressed \
        | noglob jq -r .hits.hits[]._source.package_attr_name)


    compadd $COMPREPLY
}

compdef _nix-args nix-args



autoload bashcompinit
bashcompinit

pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

bindkey -r ^V

autoload -U promptinit; promptinit
prompt pure

