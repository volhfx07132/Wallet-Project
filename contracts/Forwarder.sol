pragma solidity >=0.5.0 <0.8.0;
import "./Erc20.sol";
/**
 * Contract that will forward any incoming Ether to the creator of the contract
 */
contract Forwarder {
  // Address to which any funds sent to this contract will be forwarded
  address payable public destination;
  bool public inititalised = false;

  event ForwarderDeposited(address from, uint value, bytes data);
  event TokensFlushed(address forwarderAddress, uint value, address tokenContractAddress);

  /**
   * Create the contract, and sets the destination address to that of the creator
   * set initialised true for the default forwarder on normal contract deployment
   */
  constructor() payable {
    destination = msg.sender;
    inititalised = true;
  }


  modifier onlyDestination {
    if (msg.sender != destination) {
      revert("Only destination");
    }
    _;
  }
  
  //if forwarder is deployed.. forward the payment straight away
  receive() external payable {
     destination.transfer(msg.value);
     emit ForwarderDeposited(msg.sender, msg.value, msg.data);
  }

  //init on create2
  function init(address payable newDestination) public {
      if(!inititalised){
          destination = newDestination;
          inititalised = true;
      }
  }
  
  function changeDestination(address payable newDestination) public onlyDestination{
      destination = payable(newDestination);
  }

  //flush the tokens
  function flushTokens(address tokenContractAddress) public {
    IERC20 instance = IERC20(tokenContractAddress);
    uint256 forwarderBalance = instance.balanceOf(address(this));
    if (forwarderBalance == 0) {
      revert();
    }
    if (!instance.transfer(destination, forwarderBalance)) {
      revert();
    }
    emit TokensFlushed(address(this), forwarderBalance, tokenContractAddress);
  }

  function flush() payable public {
    address payable thisContract = address(this);
    destination.transfer(thisContract.balance);
  }

  function getValueOfAddress(address _address) public view returns(uint256){
    return _address.balance;
  }
  
  //simple withdraw instead of flush
  function withdraw() payable external onlyDestination{
      address payable thisContract = address(this);
      msg.sender.transfer(thisContract.balance);
  }
}
