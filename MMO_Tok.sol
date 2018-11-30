pragma solidity ^0.4.20;

contract MMO_TOK {
    address Owner;
    uint StartingPrice;
    uint Price;
    string Attributes;
    uint Token_Id;

    uint MaxDuration = 24 hours;
    uint MinDuration = 1 hours;
    uint AuctionEndTime;
    bool Ended;

    address HighestBidder;
    address Bidder;
    uint HighestBid;

    address Buyer;

    uint Bidders;

    constructor (address _Owner, uint _StartingPrice, string memory _Attributes, uint _Duration) public {
        this.Owner = _Owner;
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
        HighestBidder.transfer(highestBid) to Owner;
        Owner.transfer(Token_Id) to HighestBidder;
    }

    function Withdraw() public {
        Ended = true;
    }

    function Sell() public {
        Owner.transfer(Token_Id) to Buyer;
    }

    function DishonestyCheck() public {
        if Bidder.account <= 0 {
            assert(false);
        }
        else if Bidder.account is in ban list {
            assert(false);
        }
    }

}
