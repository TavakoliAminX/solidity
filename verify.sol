// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Verify {
    
    // Main function to verify if the signature (_sig) was created by the signer (_singer)
    // for the given message (_message).
    // Returns true if the recovered address matches the signer address.
    function verify(address _singer, string memory _message, bytes memory _sig) external pure returns (bool) {
        // Get the hash of the original message
        bytes32 messageHash = getMessageHash(_message);
        
        // Prefix the message hash with Ethereum signed message prefix and hash it again
        bytes32 ethMessageHash = getETHMessageHash(messageHash);
        
        // Recover the signer address from the signature and compare with _singer
        return recover(ethMessageHash, _sig) == _singer;
    }

    // Returns the keccak256 hash of the original message string.
    function getMessageHash(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    // Returns the Ethereum Signed Message hash, which prefixes the original hash with
    // "\x19Ethereum Signed Message:\n32" and then hashes again.
    // This is the standard used by Ethereum's personal_sign method.
    function getETHMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    // Recovers the signer address from the Ethereum signed message hash and the signature.
    function recover(bytes32 _ethMessageHash, bytes memory _sig) public pure returns (address) {
        // Split the signature into r, s, v components
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        
        // Use ecrecover to get the address that signed this hash
        return ecrecover(_ethMessageHash, v, r, s);
    }

    // Internal helper function to split the signature into r, s, and v variables.
    // Signature is expected to be 65 bytes long: r(32 bytes) + s(32 bytes) + v(1 byte)
    function _split(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "Invalid signature length");
        assembly {
            // First 32 bytes after the length prefix store r
            r := mload(add(_sig, 32))
            // Next 32 bytes store s
            s := mload(add(_sig, 64))
            // The final byte stores v
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}
