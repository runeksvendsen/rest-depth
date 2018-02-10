# Cryptocurrency market depth REST server

RESTful HTTP server that can be used to perform various queries on several cryptocurrency markets.

## Endpoints

### `/list_venues`
*Return a list of supported venues*

Example response:

```
["bitfinex","bittrex","binance","bitstamp"]
```

### `/:venue/list_markets`
*Return a list of markets for the given venue*

Parameters: 
* **venue** (a venue name returned by `list_venues`)

Example response:
```
["BTC-USD-btcusd","LTC-USD-ltcusd","LTC-BTC-ltcbtc","ETH-USD-ethusd","ETH-BTC-ethbtc","ETC-BTC-etcbtc","ETC-USD-etcusd","RRT-USD-rrtusd","RRT-BTC-rrtbtc","ZEC-USD-zecusd","ZEC-BTC-zecbtc","XMR-USD-xmrusd","XMR-BTC-xmrbtc","DSH-USD-dshusd","DSH-BTC-dshbtc","BTC-EUR-btceur","XRP-USD-xrpusd","XRP-BTC-xrpbtc","IOT-USD-iotusd","IOT-BTC-iotbtc","IOT-ETH-ioteth","EOS-USD-eosusd","EOS-BTC-eosbtc","EOS-ETH-eoseth","SAN-USD-sanusd","SAN-BTC-sanbtc","SAN-ETH-saneth","OMG-USD-omgusd","OMG-BTC-omgbtc","OMG-ETH-omgeth","BCH-USD-bchusd","BCH-BTC-bchbtc","BCH-ETH-bcheth","NEO-USD-neousd","NEO-BTC-neobtc","NEO-ETH-neoeth","ETP-USD-etpusd","ETP-BTC-etpbtc","ETP-ETH-etpeth","QTM-USD-qtmusd","QTM-BTC-qtmbtc","QTM-ETH-qtmeth","AVT-USD-avtusd","AVT-BTC-avtbtc","AVT-ETH-avteth","EDO-USD-edousd","EDO-BTC-edobtc","EDO-ETH-edoeth","BTG-USD-btgusd","BTG-BTC-btgbtc","DAT-USD-datusd","DAT-BTC-datbtc","DAT-ETH-dateth","QSH-USD-qshusd","QSH-BTC-qshbtc","QSH-ETH-qsheth","YYW-USD-yywusd","YYW-BTC-yywbtc","YYW-ETH-yyweth","GNT-USD-gntusd","GNT-BTC-gntbtc","GNT-ETH-gnteth","SNT-USD-sntusd","SNT-BTC-sntbtc","SNT-ETH-snteth","IOT-EUR-ioteur","BAT-USD-batusd","BAT-BTC-batbtc","BAT-ETH-bateth","MNA-USD-mnausd","MNA-BTC-mnabtc","MNA-ETH-mnaeth","FUN-USD-funusd","FUN-BTC-funbtc","FUN-ETH-funeth","ZRX-USD-zrxusd","ZRX-BTC-zrxbtc","ZRX-ETH-zrxeth","TNB-USD-tnbusd","TNB-BTC-tnbbtc","TNB-ETH-tnbeth","SPK-USD-spkusd","SPK-BTC-spkbtc","SPK-ETH-spketh","TRX-USD-trxusd","TRX-BTC-trxbtc","TRX-ETH-trxeth","RCN-USD-rcnusd","RCN-BTC-rcnbtc","RCN-ETH-rcneth","RLC-USD-rlcusd","RLC-BTC-rlcbtc","RLC-ETH-rlceth","AID-USD-aidusd","AID-BTC-aidbtc","AID-ETH-aideth","SNG-USD-sngusd","SNG-BTC-sngbtc","SNG-ETH-sngeth","REP-USD-repusd","REP-BTC-repbtc","REP-ETH-repeth","ELF-USD-elfusd","ELF-BTC-elfbtc","ELF-ETH-elfeth"]
```
 
### `/:venue/slippage_sell/:market/:slippage`
*Find out how much can be sold while, at most, lowering the price by the specified percentage*

Parameters: 
* **venue** (a venue name returned by `list_venues`)
* **market** (market name returned by `list_markets`)
* **slippage** (target slippage, in percent)
  
  
### `/:venue/slippage_buy/:market/:slippage`
*Find out how much can be bought while, at most, increasing the price by the specified percentage*

Parameters: 
* **venue** (a venue name returned by `list_venues`)
* **market** (market name returned by `list_markets`)
* **slippage** (target slippage, in percent)
   
   
