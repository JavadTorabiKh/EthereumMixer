// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Mixer {
    struct Deposit {
        bytes32 commitment;
        bool withdrawn;
    }

    mapping(bytes32 => Deposit) public deposits;
    bytes32 public merkleRoot;

    event Deposited(bytes32 indexed commitment);
    event Withdrawn(bytes32 indexed commitment, address indexed recipient);

    function deposit(bytes32 _commitment) public {
        require(deposits[_commitment].commitment == 0, "Commitment already exists");
        
        deposits[_commitment] = Deposit({
            commitment: _commitment,
            withdrawn: false
        });

        emit Deposited(_commitment);
    }

    function withdraw(bytes32 _commitment, bytes32[] calldata _proof, address _recipient) public {
        require(deposits[_commitment].commitment != 0, "Commitment does not exist");
        require(!deposits[_commitment].withdrawn, "Already withdrawn");

        // Verify the Merkle proof
        bytes32 leaf = _commitment;
        require(MerkleProof.verify(_proof, merkleRoot, leaf), "Invalid proof");

        deposits[_commitment].withdrawn = true;
        payable(_recipient).transfer(1 ether); // Adjust the amount as needed

        emit Withdrawn(_commitment, _recipient);
    }

    function setMerkleRoot(bytes32 _merkleRoot) public {
        merkleRoot = _merkleRoot;
    }
}