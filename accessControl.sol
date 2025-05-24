// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Access {

    // Nested mapping to keep track of roles assigned to addresses
    // roles[roleHash][address] => bool (true if the address has the role)
    mapping (bytes32 => mapping (address => bool)) public roles;

    // Define constant role identifiers by hashing their string names
    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));

    // Events emitted when roles are granted or revoked
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    // Constructor assigns the deploying address the ADMIN role
    constructor() {
        _grant(ADMIN, msg.sender);
    }

    // Modifier to restrict function access to only addresses that have the ADMIN role
    modifier onlyAdmin(bytes32 _role) {
        require(roles[_role][msg.sender], "AccessControl: not an admin");
        _;
    }

    // Internal function to grant a role to an account
    // Emits a GrantRole event
    function _grant(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    // Public function that allows an admin to grant a role to an account
    function grant(bytes32 _role, address _account) external onlyAdmin(ADMIN) {
        _grant(_role, _account);
    }

    // Internal function to revoke a role from an account
    // Emits a RevokeRole event
    function _revoke(bytes32 _role, address _account) internal {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }

    // Public function that allows an admin to revoke a role from an account
    // The onlyAdmin modifier ensures only admins can call this
    function revoke(bytes32 _role, address _account) external onlyAdmin(ADMIN) {
        _revoke(_role, _account);
    }
}
