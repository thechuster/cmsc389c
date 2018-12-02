pragma solidity ^0.5.0;

import "browser/ERC721.sol";

contract MMO_TOK is ERC721 {
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
    bool SellBool;

    address[] BanList = new address[](2^256-1);

    struct Bidder{
        address AddressOfBidder;
        uint NumberOfBids;
    }
    Bidder[] BidderArray;


    modifier OwnerFunc {
        require(Owner == msg.sender);
        _;
    }

     constructor (address _Owner, uint _StartingPrice,
     string memory _Attributes, uint _Duration, bool _SellBool,
     uint _Token_Id) public {
        Owner = _Owner;
        StartingPrice = _StartingPrice;
        Attributes = _Attributes;
        EndBool = false;
        SellBool = _SellBool;
        TotalNumberOfBidders = 0;
        Token_Id = _Token_Id;
        BidderArray = new Bidder[](100);


        if (_Duration >= MinDuration && _Duration <= MaxDuration) {
            AuctionEndTime = now + _Duration;
        } else if (_Duration < MinDuration) {
            AuctionEndTime = now + MinDuration;
        } else {
            AuctionEndTime = now + MaxDuration;
        }
     }

     function getEndTime() public view returns(uint) {
        return AuctionEndTime;
    }

    function getStartingPrice() public view returns(uint) {
        return StartingPrice;
    }

    function getHighestBid() public view returns(uint) {
        if (SellBool == true) {
            revert();
        }
        return HighestBid;
    }

    function getTotalNumberOfBidders() public view returns(uint) {
         if (SellBool == true) {
            revert();
        }
        return TotalNumberOfBidders;
    }

     // TODO: set limit on bids per participant
     function UpdateBid(address Bidder, uint Bid) public returns (bool) {
        if(EndBool == false || TotalNumberOfBidders >= 100) {
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

    function EndAuction() private {

    }

    function WithdrawBid(address _Bidder) public {
        require(FindBidder(_Bidder));
        // TODO: add code to remove bidder from the bidder array
        TotalNumberOfBidders--;
    }

    function UpdateTime(uint NewTime) OwnerFunc external {
        if (AuctionEndTime + NewTime < MaxDuration) {
            AuctionEndTime = AuctionEndTime + NewTime;
        }
        else {
            AuctionEndTime = MaxDuration;
        }
    }

    function Buy(address _Buyer) public view {
        if (EndBool) {
            revert();
        }
        else if (SellBool) {
            // TODO: Transfer();
        }
    }

    // TODO:function Transfer() public payable {

    // }

    function FindBidder(address _Bidder) private view returns(bool) {
        for (uint i = 0; i < 100; i++) {
            if (BidderArray[i].AddressOfBidder == _Bidder) {
                return true;
            }
        }
        return false;
    }

    function FindNumberOfBids(address _Bidder) private view returns (uint) {
        for (uint i = 0; i < 100; i++) {
            if (BidderArray[i].AddressOfBidder == _Bidder) {
                return BidderArray[i].NumberOfBids;
            }
        }
    }

    function EndBid() OwnerFunc external{
        EndBool = true;
    }

    function AddToBanList(address BannedUser) private {
        BanList.push(BannedUser);
    }
}
