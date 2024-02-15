// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Parent contract - Marketplace
contract Marketplace {
    // Storage variables - stored on the blockchain
    address private owner;
    
    // Constructor
    constructor() {
        owner = msg.sender;
    }
    
    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can access this function");
        _;
    }
    
    // Function in the parent contract
    function commonFunction() public pure returns (string memory) {
        return "This is a common function in the Marketplace contract";
    }
}

// Child contract 1 - ItemListing
contract ItemListing is Marketplace {
    // Storage variables of the child contract - stored on the blockchain
    mapping(address => Item[]) private sellerItems;
    
    struct Item {
        string name;
        string description;
        uint256 price;
        uint256 quantity;
        address owner;
    }
    
    // Function in the child contract
    function listItem(
        string memory _name,
        string memory _description,
        uint256 _price,
        uint256 _quantity
    ) public onlyOwner {
        // ...
    }
}

// Child contract 2 - ItemPurchase
contract ItemPurchase is Marketplace {
    // Storage variables of the child contract - stored on the blockchain
    mapping(address => Item) private purchasedItems;
    
    struct Item {
        string name;
        uint256 price;
        uint256 quantity;
        address seller;
    }
    
    // Function in the child contract
    function purchaseItem(address _seller, uint256 _itemId, uint256 _quantity) public onlyOwner {
        // ...
    }
}
