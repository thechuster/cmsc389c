pragma solidity ^0.5.0;

contract MMO_TOK {
    address private Owner;
    uint private StartingPrice;
    string private Attributes;
    uint private Token_Id;

    uint private MaxDuration = 48 hours;
    uint private MinDuration = 1 hours;
    uint private AuctionEndTime;
    bool private EndBool;

    address private Buyer;
    address private HighestBidder;
    uint private TotalNumberOfBidders;
    uint private HighestBid;
    bool InstantSell;

    address[] BanList = new address[](2^256-1);
    struct Bidder{
        address Address;
        uint NumberOfBids;
    }

     constructor (address _Owner, uint _StartingPrice, string memory _Attributes, uint _Duration, bool _InstantSell) public {
        Owner = _Owner;
        StartingPrice = _StartingPrice;
        Attributes = _Attributes;
        EndBool = false;
        InstantSell = _InstantSell;
        TotalNumberOfBidders = 0;
        Bidder[] memory BidderArray = new Bidder[](100);

        if (_Duration >= MinDuration && _Duration <= MaxDuration) {
            AuctionEndTime = now + _Duration;
        } else if (_Duration < MinDuration) {
            AuctionEndTime = now + MinDuration;
        } else {
            AuctionEndTime = now + MaxDuration;
        }
     }
     // set limit on bids per participant
     function UpdateBid(address Bidder, uint Bid) public returns (bool) {
        if(EndBool || TotalNumberOfBidders >= 100) {
            revert();
        }
        if (Bid > HighestBid && Bid >= StartingPrice) {
                HighestBidder = Bidder;
                HighestBid = Bid;
                TotalNumberOfBidders += 1;
                return true;
        }
        return false;
    }

    function UpdateTime(uint NewTime) public {
        if (AuctionEndTime + NewTime < MaxDuration) {
            AuctionEndTime = AuctionEndTime + NewTime;
        }
        else {
            AuctionEndTime = MaxDuration;
        }
    }
    function Sell(address _Buyer) public {
        if (EndBool) {
            revert();
        }
        Transfer(_Buyer);
    }

    function Transfer(address _Buyer) public payable {

    }

    // function FindNumberOfBids(address _Bidder) private returns (uint) {
    //     for (uint i = 0; i < 100; i++) {
    //         if (BidderArray[i].Address == _Bidder) {
    //             return Bidder[i].NumberOfBids;
    //         }
    //     }
    // }

    function EndBid() public{
        EndBool = true;
    }
    function AddToBanList(address BannedUser) private {
        BanList.push(BannedUser);
    }
}
