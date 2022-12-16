//SPDX-License-Identifier: MIT
// This demo contract is generated automatically by saas3
// EDIT it to adapt to your own dAPI
pragma solidity 0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Utils.sol";
import "./Interfaces.sol";

contract CoinPrice is Ownable, Utils, Mo {
    /// @dev result, set it to public, so we can check directly
    uint256 public result;

    /// @dev saas3 protocol contract address
    address private oracle;

    /// @dev phala anchor contract address
    address private anchor;

    /// @dev we should not hardcode saas3 address in case of saas3 protocol contract upgrade
    function set_oracle(
        address oracle_addr,
        address phat_anchor_addr
    ) external onlyOwner {
        oracle = oracle_addr;
        anchor = phat_anchor_addr;
    }

    /// @dev main procedure to call oracle service
    function ask() public {
         require(
            msg.sender == owner(),
            "Unauthorized msg sender!"
        );
        /// @dev anchor will check in oracle contract, we don't need to check it here
        require(oracle != address(0), "oracle address not set");

        // get match id by home and guest team name
        bytes memory parameters = abi.encode(
                bytes32("1sss"),
                bytes32("ids"),
                "ethereum",
                bytes32("vs_currencies"),
               "usd",
                bytes32("_path"), // _path, _type and _times are optional, you can set them in druntime side.
                "ethereum.usd",
                bytes32("_type"),
                "uint256",
                bytes32("_times"),
                "100"
            );

        // do the request
        IsAsking(oracle).ask(
            anchor,
            address(this),
            this.reply.selector,
            parameters
        );
    }

    /// @dev callback fn for allowing protocol contract to set oracle result back
    /// require to check the msg.sender

    function reply(uint256 id, bytes calldata data) external override {
        require(
            msg.sender == owner() || msg.sender == oracle,
            "Unauthorized msg sender!"
        );

        // decode your result data here
        result = abi.decode(data, (uint256));
    }
}
