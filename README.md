# Cryptocurrency market depth REST server

RESTful HTTP server that can be used to perform various queries on several cryptocurrency markets.

## Endpoints

### `/list_venues`
*Return a list of supported venues*

### `/:venue/list_markets`
*Return a list of markets for the given venue*

Parameters: 
* **venue** (a venue name returned by `list_venues`)
 
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
   
   
