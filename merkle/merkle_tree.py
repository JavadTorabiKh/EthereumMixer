import hashlib
from merkletools import MerkleTools


class MerkleTree:
    def __init__(self):
        self.merkle_tools = MerkleTools()

    def add_commitment(self, commitment):
        # Add a commitment to the Merkle tree
        self.merkle_tools.add_leaf(commitment, True)

    def build_tree(self):
        # Build the Merkle tree
        self.merkle_tools.make_tree()

    def get_root(self):
        # Get the root of the Merkle tree
        return self.merkle_tools.get_merkle_root()

    def get_proof(self, index):
        # Get proof for a specific commitment
        return self.merkle_tools.get_proof(index)


# Example usage
if __name__ == "__main__":
    tree = MerkleTree()
    commitments = [
        hashlib.sha256(b'commitment1').hexdigest(),
        hashlib.sha256(b'commitment2').hexdigest(),
        hashlib.sha256(b'commitment3').hexdigest()
    ]

    for commitment in commitments:
        tree.add_commitment(commitment)

    tree.build_tree()
    print("Merkle Root:", tree.get_root())

    # Get proof for the first commitment
    proof = tree.get_proof(0)
    print("Proof for commitment1:", proof)
