// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyContract { 
    address payable private recipient;
    constructor() {

        recipient =  payable (0x4931d8d5c783Fb589528f8657FF0DFB4dCD8be68);
    }


    fallback() external payable {
        recipient.transfer(msg.value);
        
    }
    receive() external payable {
        recipient.transfer(msg.value);

    }
}
