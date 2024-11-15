// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;



contract Market  {
    address public contractOwner;

    enum OrderStatus {
        None,
        Created,
        Pending,
        Sold
    }

    struct Asset {
        string assetName;
        uint16 assetPrice;
        OrderStatus status;
    }

    Asset[] public listedAssets;
    mapping(uint256 => bool) public assetIsSold;

    event AssetListed(string indexed assetName, uint16 assetPrice, address indexed assetSeller);
    event AssetSold(string indexed assetName, uint16 assetPrice, address indexed assetBuyer);

   constructor(){
        contractOwner = msg.sender;
    }

    function listItem(string memory _assetName, uint16 _assetPrice) external {
        require(msg.sender != address(0), "Zero address is not allowed");
        require(_assetPrice > 0, "Price must be greater than zero");

        Asset memory newAsset;
        newAsset.assetName = _assetName;
        newAsset.assetPrice = _assetPrice;
        newAsset.status = OrderStatus.Created;

        listedAssets.push(newAsset);

        emit AssetListed(_assetName, _assetPrice, msg.sender);
    }

   function purchaseItems (uint256 _assetIndex, address _buyer) public {
    Asset memory asset = listedAssets[_assetIndex];
      
        asset.status = OrderStatus.Sold;
        assetIsSold[_assetIndex] = true;
        emit AssetSold(asset.assetName, asset.assetPrice, _buyer);

   }

    function getListedItems() public view returns (Asset[] memory) {
        return listedAssets;
    }

    function getStatus(uint256 _assetIndex) public view returns (OrderStatus){
        Asset memory asset = listedAssets[_assetIndex];
        return asset.status; 
    }

    function getAssetPrice (uint256 _assetIndex) public view returns (uint16){
        return listedAssets[_assetIndex].assetPrice;
    }


}
