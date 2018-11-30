pragma solidity ^0.4.6;

contract MMO_TOK {
    struct Item {
        string Attributes;
    }
    
    address SellingUser;
    uint StartingPrice;
    Item Item;
    
    uint MaxDuration = 24 hours;
    uint MinDuration = 1 hours;
    uint AuctionEndTime;
    bool Ended;
    
    address HighestBidder;
    uint HighestBid;
    
    uint Bidders;
    
    address[] ProhibitedUser = new address[](256);
    
    constructor (address _SellingUser, uint _StartingPrice, string memory _Attributes, uint _Duration, Item _Item) public {
        this.SellingUser = _SellingUser;
        this.StartingPrice = _StartingPrice;
        
        this.Ended = false;
        this.Bidders = 0;
        
        this.Item = _Item;
        this.Item.Attributes += _Attributes;
        
        if (_Duration >= MinDuration && _Duration <= MaxDuration) {
            this.AuctionEndTime = now + _Duration;
        } else if (_Duration < MinDuration) {
            this.AuctionEndTime = now + MinDuration;
        } else {
            this.AuctionEndTime = now + MaxDuration; 
        }
    }
    
    function CreateBid(address Bidder, uint Bid) public returns (bool) {
        require(!Ended, "Auction has ended.");
        
        if (Bid > HighestBid && Bid >= StartingPrice) {
            if (balanceOf(Bidder) >= Bid) { // correct way to find highest bidder?
                HighestBidder = Bidder;
                HighestBid = Bid;
            
                Bidders += 0;
            
                return true;
            }
        }
        
        return false;
    }
    

    function AuctionEnd() public {
        require(now >= AuctionEndTime, "Auction hasn't ended yet.");
        require(!Ended, "This function has not been called.");

        Ended = true;
        HighestBidder.transfer(item);
    }
}