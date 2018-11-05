pragma solidity ^0.4.24;

import "./implementation/Standard223Token.sol";

contract XMP is Standard223Token {
  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // Requires that before a function executes either:
  // The global isThawed value is set true
  // The sender is in a whitelisted thawedAddress
  // It has been a year since contract deployment
  modifier requireThawed() {
    require(isThawed == true || thawedAddresses[msg.sender] == true || now > thawTime);
    _;
  }

  // Applies to thaw functions. Only the designated manager is allowed when this modifier is present
  modifier onlyManager() {
    require(msg.sender == owner || msg.sender == manager);
    _;
  }

  address owner;
  address manager;
  uint initialBalance;
  string public name;
  string public symbol;
  uint public decimals;
  mapping (uint=>string) public metadata;
  mapping (uint=>string) public publicMetadata;
  bool isThawed = false;
  mapping (address=>bool) public thawedAddresses;
  uint256 thawTime;

  constructor() public {
    address bountyMgrAddress = address(0x03de5f75915dc5382c5df82538f8d5e124a7ebb8);
    
    initialBalance = 18666666667 * 1e8;
    uint256 bountyMgrBalance = 933333333 * 1e8;
    totalSupply = initialBalance;

    balances[msg.sender] = safeSub(initialBalance, bountyMgrBalance);
    balances[bountyMgrAddress] = bountyMgrBalance;

    Transfer(address(0x0), address(msg.sender), balances[msg.sender]);
    Transfer(address(0x0), address(bountyMgrAddress), balances[bountyMgrAddress]);

    name = "PowerCore";
    symbol = "XMP";
    decimals = 8;
    owner = msg.sender;
    thawedAddresses[msg.sender] = true;
    thawedAddresses[bountyMgrAddress] = true;
    thawTime = now + 1 years;
  }

  // **
  // ** Manager functions **
  // **
  // Thaw a specific address, allowing it to send tokens
  function thawAddress(address _address) onlyManager {
    thawedAddresses[_address] = true;
  }
  // Thaw all addresses. This is irreversible
  function thawAllAddresses() onlyManager {
    isThawed = true;
  }
  // Freeze all addresses except for those whitelisted in thawedAddresses. This is irreversible
  // This only applies if the thawTime has not yet past.
  function freezeAllAddresses() onlyManager {
    isThawed = false;
  }

  // **
  // ** Owner functions **
  // **
  // Set a new owner
  function setOwner(address _newOwner) onlyOwner {
    owner = _newOwner;
  }

  // Set a manager, who can unfreeze wallets as needed
  function setManager(address _address) onlyOwner {
    manager = _address;
  }

  // Change the ticker symbol of the token
  function changeSymbol(string newSymbol) onlyOwner {
    symbol = newSymbol;
  }

  // Change the long-form name of the token
  function changeName(string newName) onlyOwner {
    name = newName;
  }

  // Set any admin level metadata needed for XMP mainnet purposes
  function setMetadata(uint key, string value) onlyOwner {
    metadata[key] = value;
  }

  // **
  // ** Public functions **
  // **
  // Set any public metadata needed for XMP mainnet purposes
  function setPublicMetadata(uint key, string value) {
    publicMetadata[key] = value;
  }

  // Standard ERC20 transfer commands, with additional requireThawed modifier
  function transfer(address _to, uint _value, bytes _data) requireThawed returns (bool success) {
    return super.transfer(_to, _value, _data);
  }
  function transferFrom(address _from, address _to, uint _value, bytes _data) requireThawed returns (bool success) {
    return super.transferFrom(_from, _to, _value, _data);
  }
  function transfer(address _to, uint _value) requireThawed returns (bool success) {
    return super.transfer(_to, _value);
  }
  function transferFrom(address _from, address _to, uint _value) requireThawed returns (bool success) {
    return super.transferFrom(_from, _to, _value);
  }

}
