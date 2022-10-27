//SPDX-License-Identifier: MIT
// This demo contract is generated automatically by saas3
// EDIT it to adapt to your own dAPI
pragma solidity 0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ask.sol";

contract FootballGame is Ownable {
    /// @dev set it to public, so we can check it directly
    /// There are two teams in a single match
    /// home vs guest
    /// result is 0 means home team lost and guest team win
    /// result is 1 means home team win and guest team lost
    /// result is 2 means draw
    uint public result;

    /// @dev saas3 protocol contract address
    address private protocol;

    /// @dev phala anchor contract address
    address private anchor;

    /// @dev mapping match id to static team parameters
    ///
    mapping(uint => bytes) game_parameters;

    constructor(address _protocol, address _anchor) {
        // init contract addresses
        protocol = _protocol;
        anchor = _anchor;

        // init game parameters
        game_parameters[1] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000005161746172000000000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000045637561646f7200000000000000000000000000000000000000000000000000"
        );
        // ...
    }

    /// @dev we should not hardcode anchor address in case of anchor contract upgrade
    function set_anchor(address _anchor) public onlyOwner {
        anchor = _anchor;
    }

    /// @dev we should not hardcode saas3 address in case of saas3 protocol contract upgrade
    function set_protocol(address _protocol) public onlyOwner {
        protocol = _protocol;
    }

    function game_result(uint match_id) public onlyOwner {
        Ask c = Ask(protocol);
        bytes memory parameters = game_parameters[match_id];

        c.ask(anchor, address(this), this.anything.selector, parameters);
    }

    function anything(bytes calldata data) public onlyOwner {
        // decode the data here
        result = abi.decode(data, (uint));
        // anything following
    }
}
