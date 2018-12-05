# CMSC389C
CMSC389C Smart Contract (Albert Chu, Josh Lord)

## Criteria
* Must be able to handle a variable amount of participants
* Must have at least one payable function
* Must punish any dishonest participants in the contract
* Must disallow new participants after the contract is over/finished (if your contract has a terminal state)

## ERC-721 Token
* Smart contract to allow bidding of items
* Items are tokens in the contract
* Allow a user to put an item up for sale
* Let multiple different users bid on the item
* The item price must update to all new and existing bidders
* Items would be bid with in game currency
* Allow bidding or instant sell
* Minimum bid
* Transfer the winning bid to the highest bidder
* Item has stats and can rack up additional stats through gameplay
* Once the item has transferred to a new owner, the stats of the item are transferred too
* Dishonest participants face banishment and also gas loss
* Keep track of time left on item
* Once the timer has run out for the item, or the seller issues a halt, then new participants are disallowed
* The seller has the option to withdraw the item before the bid finishes, or the item is sold

Our thought was that a token like this could be used to represent an item in a MMO game. The smart contract would be used as a means of a marketplace for the game and would allow users to safely and quickly trade items without worrying about dishonest participants. Video used for reference and inspiration: https://www.youtube.com/watch?v=ywvTIM_eOVI
