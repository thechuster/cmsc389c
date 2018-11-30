import "browser/MMO_TOK_Interface.sol";

contract MMO_TOK is ERC721 {
    address SellingUser;
    uint StartingPrice;
    string Attributes;
    
    uint ActionEndTime;
    bool ended;
    
    address HighestBidder;
    unit HighestBid;
    
    constructor (address SellingUser, int16 StartingPrice, string Attributes) public {
        this.SellingUser = SellingUser;
        this.StartingPrice = StartingPrice;
        this.Attributes = Attributes;
        
        this.ended = false;
    }
}