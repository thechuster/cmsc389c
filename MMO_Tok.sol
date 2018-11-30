contract MMO_TOK {
    address SellingUser;
    uint StartingPrice;
    string Attributes;
    
    uint MaxDuration = 24 hours;
    uint MinDuration = 1 hours;
    uint AuctionEndTime;
    bool Ended;
    
    address HighestBidder;
    uint HighestBid;
    
    uint Bidders;
    
    constructor (address _SellingUser, uint _StartingPrice, string memory _Attributes, uint _Duration) public {
        this.SellingUser = _SellingUser;
        this.StartingPrice = _StartingPrice;
        this.Attributes = _Attributes;
        
        this.Ended = false;
        this.Bidders = 0;
        
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
        require(!ended, "This function has not been called.");

        ended = true;
        HighestBidder.transfer(highestBid);
    }
}