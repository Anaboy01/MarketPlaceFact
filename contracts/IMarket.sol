// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;


interface IMarket {
    enum OrderStatus {
        None,
        Created,
        Pending,
        Sold
    }
       
    struct Asset {
        string assetName;
        uint16 assetPrice;
        address assetSeller;
        OrderStatus status;
    }


    
    function listItem(string memory _assetName, uint16 _assetPrice,address _assetSeller) external;
    function purchaseItems (uint256 _assetIndex, address _buyer) external;
    function getListedItems() external  view returns (Asset[] memory) ;
    function getAssetPrice (uint256 _assetIndex) external view returns( uint16);

}