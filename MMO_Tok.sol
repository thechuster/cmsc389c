pragma solidity ^0.5.0;

contract MMO_TOK {
    address private Owner;
    uint private StartingPrice;
    string private Attributes;
    mapping (uint => address) TokenOwner;
    mapping (uint => string) ItemAttributes;
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
        Token_Id = _Token_Id;
        TokenOwner[_Token_Id] = _Owner;
        ItemAttributes[_Token_Id] = _Attributes;
        _Attributes = Attributes;
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

     // Udates the bid whenever someone enters a new bid
     function UpdateBid(address _Bidder, uint _Bid) external {
         CheckAuctionEnd();
         require(BlockedUsers[_Bidder] == false);
        if(EndBool == false || TotalNumberOfBidders >= 100 || SellBool == true) {
            revert();
        }
        if (_Bid > HighestBid && _Bid >= StartingPrice) {
                if (Bidders[_Bidder] == 0) {
                    HighestBidder = _Bidder;
                    HighestBid = _Bid;
                    TotalNumberOfBidders += 1;
                    Bidders[_Bidder] += 1;
                }
                else if (Bidders[_Bidder] > 100) {
                    AddToBlockList(_Bidder);
                }
                else if (_Bidder == Owner) {
                    AddToBlockList(Owner);
                    EndBool = true;
                }
                else {
                    HighestBidder = _Bidder;
                    HighestBid = _Bid;
                    Bidders[_Bidder] += 1;
                }
        }
    }

    // Checks to see if the auction has ended
    function CheckAuctionEnd() private {
        if (now >= AuctionEndTime){
            EndBool = true;
            TransferToken(Owner, HighestBidder, Token_Id);
        }
    }

    // This allows a bidder to withdraw their bid from the mapping
    // of bidders and decreases the TotalNumberOfBidders
    // Once withdrawn the bidder cannot bid again
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

    // Function allows for the owner to instantly tranfer their token to the first buyer.
    function Sell(address _Buyer) external {
        if (EndBool) {
            revert();
        }
        else if (SellBool) {
            EndBool = true;
            Buyer = _Buyer;
            TransferToken(Owner, _Buyer, Token_Id);
        }
    }

    // Finds the number of bids a bidder has made
    function FindNumberOfBids(address _Bidder) private view returns (uint) {
        return Bidders[_Bidder];
    }

    // Function for the owner to manually end the bid.
    function EndBidding(bool confirmtransfer) OwnerFunc external {
        EndBool = true;
        if (SellBool == false && confirmtransfer == true) {
            TransferToken(Owner, HighestBidder, Token_Id);
        }
    }

    // Function that transfers to ownership to the highest bidder or to the buyer
    // If _from is not owner they are banned, if _to is not the highest
    function TransferToken(address _from, address _to, uint256 _tokenId) public payable {
        require(EndBool == true);
        if (SellBool == false && _to != HighestBidder) {
            AddToBlockList(_to);
        }
        if (SellBool == true && _to != Buyer) {
            AddToBlockList(_to);
        }
        if (TokenOwner[_tokenId] != _from) {
            AddToBlockList(_from);
        }
        else {
        TokenOwner[_tokenId] = _to;
        }
    }

    // Function to add user to BlockedUsers
    function AddToBlockList(address BannedUser) private {
        BlockedUsers[BannedUser] = true;
    }
}
