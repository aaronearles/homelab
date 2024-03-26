ZONEID="3df85645994c6bd1399d9a2221ef6213" #EARLES.IO ZONE
TOKEN="hiuZFj9GyYMVY9Qv5PjoorK4quB3pw5GWBv3EzZu"
URL="https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records"
curl --request GET --url $URL -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}"