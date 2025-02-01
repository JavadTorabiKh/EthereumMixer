// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./add.sol";
import "./safeMath.sol";

contract Mixer {

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


    function flush(address _to, count) private {
        uint256 value = (address(this).balance).div(50);

        if (value == 0) {
            return;
        }

        for (uint256 i = 0; i < count; i++) {
            calls(value.mul(count),_to);
        }

    }

    function calls(uint256 value, address _to) private  {
        (bool success, ) = _to.call{value: value}("");
        require(success, "mix failed");
    }
}
