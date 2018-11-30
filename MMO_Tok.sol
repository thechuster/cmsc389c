import "brower/MMO_TOK_Interface.sol";

contract MMO_TOK is ERC721 {
    address SellingUser;
    uint StartingPrice;
    string Attributes;
    
    uint ActionEndTime;
    bool ended;
    
    address HighestBidder;
    unit HighestBid;
    
    constructor (address SellingUser, uint StartingPrice, string Attributes) public {
        this.SellingUser = SellingUser;
        this.StartingPrice = StartingPrice;
        this.Attributes = Attributes;
        
        this.ended = false;
    }
    
    function CreateBid(address Bidder, uint Bid) public returns (bool) {
        if (ended) {
            return false;
        }
        
        if (Bid > HighestBid && Bid >= StartingPrice) {
            // Check Bidders Balance
            HighestBidder = Bidder;
            HighestBid = Bid;
            
            return true;
        }
        
        return false;
    }
}