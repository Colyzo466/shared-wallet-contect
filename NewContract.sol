// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract ItemListing {
    struct Item {
        string name;
        string description;
        uint256 price;
        uint256 quantity;
        address owner;
    }

    mapping(address => Item[]) private sellerItems;

    event ItemListed(address indexed seller, uint256 indexed itemId);
    event ItemEdited(address indexed seller, uint256 indexed itemId);
    event ItemDeleted(address indexed seller, uint256 indexed itemId);
    event ItemPurchased(address indexed seller, uint256 indexed itemId, uint256 quantity);

    modifier onlyItemOwner(address _seller, uint256 _itemId) {
        require(sellerItems[_seller].length > _itemId, "Invalid item ID");
        require(sellerItems[_seller][_itemId].owner == msg.sender, "Not the item owner");
        _;
    }

    constructor() {
        // Perform any necessary initialization here
    }

    function listItem(
        string memory _name,
        string memory _description,
        uint256 _price,
        uint256 _quantity
    ) public {
        Item memory newItem = Item(_name, _description, _price, _quantity, msg.sender);
        sellerItems[msg.sender].push(newItem);
        uint256 itemId = sellerItems[msg.sender].length - 1;
        emit ItemListed(msg.sender, itemId);
    }

    function editItem(
        uint256 _itemId,
        string memory _name,
        string memory _description,
        uint256 _price,
        uint256 _quantity
    ) public onlyItemOwner(msg.sender, _itemId) {
        Item storage item = sellerItems[msg.sender][_itemId];
        item.name = _name;
        item.description = _description;
        item.price = _price;
        item.quantity = _quantity;
        emit ItemEdited(msg.sender, _itemId);
    }

    function deleteItem(uint256 _itemId) public onlyItemOwner(msg.sender, _itemId) {
        delete sellerItems[msg.sender][_itemId];
        emit ItemDeleted(msg.sender, _itemId);
    }

    function purchaseItem(address _seller, uint256 _itemId, uint256 _quantity) public payable {
        require(sellerItems[_seller].length > _itemId, "Invalid item ID");
        Item storage item = sellerItems[_seller][_itemId];
        require(item.quantity >= _quantity, "Not enough quantity available");
        require(msg.value >= item.price * _quantity, "Insufficient payment");

        item.quantity -= _quantity;
        emit ItemPurchased(_seller, _itemId, _quantity);
    }

    function getItemDetails(address _seller, uint256 _itemId) public view returns (
        string memory,
        string memory,
        uint256,
        uint256,
        address
    ) {
        require(sellerItems[_seller].length > _itemId, "Invalid item ID");
        Item memory item = sellerItems[_seller][_itemId];
        return (item.name, item.description, item.price, item.quantity, item.owner);
    }

    function callExternalContract(address _externalContract, bytes memory _data) public {
        // Call a function in an external contract
        (bool success, ) = _externalContract.call(_data);
        require(success, "External contract call failed");
    }

    function buyItem(address _seller, uint256 _itemId, uint256 _quantity, address _paymentGateway) public {
        // Check item availability
        require(sellerItems[_seller].length > _itemId, "Invalid item ID");
        Item storage item = sellerItems[_seller][_itemId];
        require(item.quantity >= _quantity, "Not enough quantity available");

        // Transfer payment to the payment gateway contract
        (bool paymentSuccess, ) = _paymentGateway.call{value: item.price * _quantity}("");
        require(paymentSuccess, "Payment failed");

        // Update item quantity
        item.quantity -= _quantity;
        emit ItemPurchased(_seller, _itemId, _quantity);
    }
}
