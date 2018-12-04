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
    bool private ConfirmTransaction;

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

    // Modifier for Owner only functions
    modifier OwnerFunc {
        require(Owner == msg.sender);
        _;
    }

    // Constructor for the contract
     constructor (address _Owner, uint _StartingPrice,
     string memory _Attributes, uint _Duration, bool _SellBool,
     uint _Token_Id, address[] memory _BanList) public {
        Owner = _Owner;
        StartingPrice = _StartingPrice;
        Attributes = _Attributes;
        EndBool = false;
        SellBool = _SellBool;
        TotalNumberOfBidders = 0;
        Token_Id = _Token_Id;
        BidderArray = new Bidder[](100);
        BanList = _BanList; // ask if you can do this
        ConfirmTransaction = false;

        if (_Duration >= MinDuration && _Duration <= MaxDuration) {
            AuctionEndTime = now + _Duration;
        } else if (_Duration < MinDuration) {
            AuctionEndTime = now + MinDuration;
        } else {
            AuctionEndTime = now + MaxDuration;
        }
     }

     // Getter for the AuctionEndTime
     function getEndTime() public view returns(uint) {
        return AuctionEndTime;
    }

    // Getter for the StartingPrice
    function getStartingPrice() public view returns(uint) {
        return StartingPrice;
    }

    // Getter for the HighestBid
    function getHighestBid() public view returns(uint) {
        if (SellBool == true) {
            revert();
        }
        return HighestBid;
    }

    // Getter for the TotalNumberOfBidders
    function getTotalNumberOfBidders() public view returns(uint) {
         if (SellBool == true) {
            revert();
        }
        return TotalNumberOfBidders;
    }

     // TODO: set limit on bids per participant
     function UpdateBid(address Bidder, uint Bid) external {
        if(EndBool == false || TotalNumberOfBidders >= 100 || SellBool == true) {
            revert();
        }
        if (Bid > HighestBid && Bid >= StartingPrice) {
                HighestBidder = Bidder;
                HighestBid = Bid;
                TotalNumberOfBidders += 1;
        }
    }

    // Ask how to do this during office hours
    function EndAuction() private {
        ConfirmTransaction = true;
    }

    // This allows a bidder to withdraw their bid from the array
    // of bidders and decreases the TotalNumberOfBidders
    function WithdrawBid(address _Bidder) external {
        require(FindBidder(_Bidder));
        // TODO: add code to remove bidder from the bidder array
        TotalNumberOfBidders--;
    }

    //Function for the owner to update the time for the auction.
    function UpdateTime(uint NewTime) OwnerFunc external {
        if (AuctionEndTime + NewTime < MaxDuration) {
            AuctionEndTime = AuctionEndTime + NewTime;
        }
        else {
            AuctionEndTime = MaxDuration;
        }
    }

    function Sell(address _Buyer) external {
        if (EndBool) {
            revert();
        }
        else if (SellBool) {
            ConfirmTransaction = true;
            // TODO: Transfer();
        }
    }

    // Checks to see if a bidder is in the array of bidders
    function FindBidder(address _Bidder) private view returns(bool) {
        for (uint i = 0; i < 100; i++) {
            if (BidderArray[i].AddressOfBidder == _Bidder) {
                return true;
            }
        }
        return false;
    }

    // Finds the number of bids a bidder has made
    function FindNumberOfBids(address _Bidder) private view returns (uint) {
        require(FindBidder(_Bidder));
        for (uint i = 0; i < 100; i++) {
            if (BidderArray[i].AddressOfBidder == _Bidder) {
                return BidderArray[i].NumberOfBids;
            }
        }
    }

    //Function for the owner to manually end the bid.
    function EndBidding(bool sell) OwnerFunc external{
        EndBool = true;
        if (sell == true) {
            ConfirmTransaction = true;
            //TODO: Transfer()
        }
    }

    // Interface function
    function approve(address _approved, uint256 _tokenId) external payable {
        emit Approval(Owner, _approved, _tokenId);
    }

    // Interface transfer function
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

        emit Transfer(_from, _to, _tokenId);
    }


    // TODO:function Transfer() public payable {

    // }

    function AddToBanList(address BannedUser) private {
        BanList.push(BannedUser);
    }
}
