// CrowdSale contract
// This crowdsale address only stores a log of what someone sends to it.
contract CrowdSale {
 uint public fIndex; //funders index
 address public CrowdSaleAddress;
 uint public deadline;

 // Events
 event FundingRecieved(address indexed From, uint indexed Amount, uint indexed BlockNumber);

 struct Funder {
   address acct;
   uint amount;
   uint blockNum;
 }

 modifier notZero(){
   if(msg.value <= 0) {throw;}
   _
 }
// if you dont have a deadline, deadline set deadline to 0
// else you do havea  deadline, lets make sure the blocks timestamp is less than the deadline
 modifier stillOpen(){
   if(deadline > 0 ) {
     if(block.timestamp < deadline){
       _
     }else{
       throw;
     }
   }else{
     _
   }
 }

 //mappings
 mapping(address=>uint) public balances;
 mapping(uint=>Funder) public funders;

 // constructor
 function CrowdSale(){
   // set CrowdSaleAddress
   CrowdSaleAddress = 0x6a620a92Ec2D11a70428b45a795909bd28AedA45; // change this address to your address obviously
   deadline = 0; // change this timestamp to your end date.
 }

 // default function
 function() returns(bool){
   // use buytoken if msg.value != 0
   return buyToken();
 }

 function buyToken() notZero() stillOpen() returns(bool){
   // send to crowdsale address
   CrowdSaleAddress.send(msg.value);
   balances[msg.sender]+=msg.value;
   // log value transfer
   funders[fIndex].acct = msg.sender;
   funders[fIndex].amount = msg.value;
   funders[fIndex].blockNum = block.number;
   fIndex++;
   // trigger event
   FundingRecieved(msg.sender, msg.value, block.number);
   // return
   return true;
 }

 // this function sums up the total of someones inputs.
 // you can also use the public balances mapping
 // the public balances mapping would be best used
 // to create new tokens in another contract
 function getAddressTotal(address _acct) returns(uint){
   uint total = 0;
   uint i = 0;
   while(i <= fIndex){
     if(_acct == funders[i].acct){
       total+=funders[i].amount;
     }
     i++;
   }
   return total;
 }

 function getTotalRaised() returns(uint){
   return CrowdSaleAddress.balance;
 }

}
