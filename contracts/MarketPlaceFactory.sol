// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// Design a Marketplace contract that allows users to register and list items for sale using a factory pattern.

// Requirements:
// The Marketplace should create a new listing contract for each user upon request.
// The Marketplace should keep a record of users and their respective listing contract addresses.

import {Market} from "./Market.sol";
import {IMarket} from "./IMarket.sol";
import {IERC20} from "./IERC20.sol";



contract MarketPlaceFactory {
   IERC20 public marketToken;

   constructor(address  _marketTokenAddr){
      marketToken = IERC20(_marketTokenAddr);
   }

   struct MarketContractInfo{
    address seller;
    address marketContract;
   }

   mapping (address => MarketContractInfo[]) public allDeployedMarkets;
   MarketContractInfo[] allMarketContracts;

    event MarketPlaceCreated(address indexed seller, address indexed  marketAddress, string indexed message);
  


   function createMarketPlace() public returns (address contractAddress_){
    
       require(msg.sender != address(0), "Zero Address not allowed ");

        address _address = address(new Market());

        contractAddress_ = _address;


        MarketContractInfo memory _deployedContract;

        _deployedContract.seller = msg.sender;
        _deployedContract.marketContract  = _address;
        
        allDeployedMarkets[msg.sender].push(_deployedContract);

        allMarketContracts.push(_deployedContract);
   }

   function getUserMarketContractByIndex (uint _index) public view returns (address seller_, address marketContract_){
     require(_index < allDeployedMarkets[msg.sender].length, "Index not found");
        MarketContractInfo memory _marketContract = allDeployedMarkets[msg.sender][_index];

        seller_=_marketContract.seller;
        marketContract_=_marketContract.marketContract;
   }

   function listItem (uint _contractIndex, uint16 _itemPrice ,string memory _itemName) public  {
   require( msg.sender != address(0), "Zero Address not allowed");
     
       (address seller_, address marketContract_) = getUserMarketContractByIndex(_contractIndex);
        address contractAdress = marketContract_; 
      IMarket(contractAdress).listItem(_itemName, _itemPrice, msg.sender);

   }

   function getAllTheMarketList() public view  returns (MarketContractInfo[] memory){
    return allMarketContracts;
   }

   function getAMarketByIndex(uint256 _contractIndex) internal  view returns (address seller_, address marketContract_){
    require (_contractIndex < allMarketContracts.length, "index not found");
        MarketContractInfo storage _marketContract = allMarketContracts[_contractIndex];
         seller_=_marketContract.seller;
         marketContract_=_marketContract.marketContract;
   }

   function buyItem (uint _contractIndex ,  uint256 _itemIndex, uint256 _amount) public {
      require( msg.sender != address(0), "Zero Address not allowed ");
     (address seller_, address marketContract_) = getAMarketByIndex(_contractIndex);
        address contractAdress = marketContract_; 
        uint16 itemPrice = IMarket(contractAdress).getAssetPrice(_itemIndex);

         require(itemPrice != _amount, "Not required token to buy") ;
         
         marketToken.transferFrom(msg.sender, seller_, _amount);
         IMarket(contractAdress).purchaseItems(_itemIndex, msg.sender);
         
   }




   
    
    receive() external payable {}
    fallback() external payable {}

}