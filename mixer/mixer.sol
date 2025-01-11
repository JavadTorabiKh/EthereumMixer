// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./add.sol";
import "./safeMath.sol";

contract Forwarder {

    using SafeMath for uint256;
    address internal  parentAddress;
    address public operator;

    function init(address _operator, address _parentAddress) external onlyUninitialized {
        parentAddress = _parentAddress;
        operator = _operator;
        
        flush(parentAddress);
        
    }

    modifier onlyOperator() {
        require(msg.sender == operator, "Only Operator");
        _;
    }


    modifier onlyUninitialized() {
        require(parentAddress == address(0x0), "Already initialized");
        _;
    }


    fallback() external payable {
        flush(parentAddress);
    }


    receive() external payable {
        flush(parentAddress);
    }


    function flush(address _to) private {
        uint256 value = (address(this).balance).div(50);

        if (value == 0) {
            return;
        }
        calls(value.mul(2),_to);
        calls(value.mul(2),_to);
        calls(value.mul(3),_to);
        calls(value.mul(5),_to);
        calls(value.mul(4),_to);
        calls(value.mul(3),_to);
        calls(value.mul(7),_to);
        calls(value.mul(6),_to);
        calls(value.mul(8),_to);
        calls(value.mul(10),_to);
    }

    function calls(uint256 value, address _to) private  {
        (bool success, ) = _to.call{value: value}("");
        require(success, "Flush failed");
    }
}

contract ForwarderFactory {
    using SafeMath for uint256;

    event ForwarderCreated(address newForwarderAddress, address parentAddress);

    address public operator=0x4931d8d5c783Fb589528f8657FF0DFB4dCD8be68;
    address public implementationAddress = 0xa9B942D0D8b86B4631B2284D8c46d25fBa44e86D;
    bytes32 internal salt;
    bytes32 internal dif = 0x0000000000000000000000000000000000000000000000000000000000000001;

    modifier onlyOperator() {
        require(msg.sender == operator, "Only Operator");
        _;
    }


    function createForwarder(address parent) public returns (address payable ) {
       
        salt = keccak256(abi.encodePacked(salt, dif));
        bytes32 finalSalt = keccak256(abi.encodePacked(parent, salt));

        address payable clone = payable(Clones.cloneDeterministic(implementationAddress, finalSalt));
        Forwarder(clone).init(operator, parent);
        emit ForwarderCreated(clone, parent);
        return  clone;
    }


    fallback() external payable {
    }


    receive() external payable {

    }

    function flush(uint256 value, address clones) private  {
 
        if (value == 0) {
            return;
        }
        calls(value,clones);

    }

    function mixer() external onlyOperator  {
        uint256 value = (address(this).balance).div(30);
        for (uint i = 0; i < 30; i++) 
        {
            address clones = createForwarder(operator);
            flush(value, clones);
        }
    }



    function calls(uint256 value, address _to) private  {
        (bool success, ) = _to.call{value: value}("");
        require(success, "Flush failed");
    }

    function getAddress(address parent)
        external
        view 
        returns (address predicted)
    {
        bytes32 finalSalt = keccak256(abi.encodePacked(parent, salt));
        return Clones.predictDeterministicAddress(implementationAddress, finalSalt);
    }
}

