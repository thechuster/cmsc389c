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

    mapping (address => bool) BlockedUsers;

    struct Bidder{
        address AddressOfBidder;
        uint NumberOfBids;
    }
    mapping (address => uint) Bidders;

    // Modifier for Owner only functions
    modifier OwnerFunc {
        require(Owner == msg.sender);
        _;
    }

    // Constructor for the contract
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

     // TODO: Add more dishonesty checks
     function UpdateBid(address _Bidder, uint _Bid) external {
         CheckAuctionEnd();
        if(EndBool == false || TotalNumberOfBidders >= 100 || SellBool == true) {
            revert();
        }
        if (_Bid > HighestBid && _Bid >= StartingPrice) {
                HighestBidder = _Bidder;
                HighestBid = _Bid;
                if (Bidders[_Bidder] == 0) {
                    TotalNumberOfBidders += 1;
                    Bidders[_Bidder] += 1;
                }
                else if (Bidders[_Bidder] >= 100) {
                    AddToBlockList(_Bidder);
                }
                else {
                    Bidders[_Bidder] += 1;
                }
        }
    }

    // Checks to see if the auction has ended
    function CheckAuctionEnd() private {
        if (now == AuctionEndTime){
            EndBool = true;
            //TODO: Transfer
        }
    }

    // This allows a bidder to withdraw their bid from the array
    // of bidders and decreases the TotalNumberOfBidders
    function WithdrawBid(address _Bidder) external {
        Bidders[_Bidder] = 0;
        BlockedUsers[_Bidder] = true;
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
            // TODO: Transfer();
        }
    }

    // Finds the number of bids a bidder has made
    function FindNumberOfBids(address _Bidder) private view returns (uint) {
        return Bidders[_Bidder];
    }

    //Function for the owner to manually end the bid.
    function EndBidding(bool sell) OwnerFunc external{
        EndBool = true;
        if (sell == true) {
            //TODO: Transfer()
        }
    }

    // TODO: IMPLEMENT TRANSFER
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        emit Transfer(_from, _to, _tokenId);
    }

    // Function to add user to BlockedUsers
    function AddToBlockList(address BannedUser) private {
        BlockedUsers[BannedUser] = true;
    }
}
