import json
import subprocess
from Crypto.Hash import SHA256


def generate_inputs(nullifier, secret, merkle_root):
    inputs = {
        "nullifier": nullifier,
        "secret": secret,
        "root": merkle_root
    }
    with open('input.json', 'w') as f:
        json.dump(inputs, f)


def generate_proof():
    # Run snarkjs command to generate proof
    subprocess.run(["snarkjs", "groth16", "fullprove", "input.json", "circuit.wasm",
                   "circuit_final.zkey", "proof.json", "public.json"], check=True)


def main():
    # Generate nullifier and secret
    nullifier = SHA256.new(b'some_random_nullifier').hexdigest()
    secret = SHA256.new(b'some_secret').hexdigest()
    merkle_root = "YOUR_MERKLE_ROOT"  # Replace with your actual Merkle root

    # Generate input JSON file
    generate_inputs(nullifier, secret, merkle_root)

    # Generate proof
    generate_proof()

    print("Proof generated successfully.")


if __name__ == "__main__":
    main()
