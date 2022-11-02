//SPDX-License-Identifier: MIT
// This demo contract is generated automatically by saas3
// EDIT it to adapt to your own dAPI
pragma solidity 0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ask.sol";
import "./AutoCallInterface.sol";

contract FootballGame is Ownable, AutoCall {
    /// @dev set it to public, so we can check it directly
    /// There are two teams in a single match
    /// home vs guest
    /// result is 0 means home team lost and guest team win
    /// result is 1 means home team win and guest team lost
    /// result is 2 means draw
    uint256 public result;

    /// @dev saas3 protocol contract address
    address private protocol;

    /// @dev phala anchor contract address
    address private anchor;

    /// @dev to indicate whether to end the game
    bool private closed = true;

    /// @dev mapping match id to static team parameters
    ///
    mapping(uint256 => bytes) game_parameters;

    constructor(address _protocol, address _anchor) {
        // init contract addresses
        protocol = _protocol;
        anchor = _anchor;
    }

    /// @dev we should not hardcode anchor address in case of anchor contract upgrade
    function set_anchor(address _anchor) public onlyOwner {
        anchor = _anchor;
    }

    /// @dev we should not hardcode saas3 address in case of saas3 protocol contract upgrade
    function set_protocol(address _protocol) public onlyOwner {
        protocol = _protocol;
    }

    /// @dev encode parameters to SaaS3 param specification
    function encode_parameters(bytes32 home, bytes32 guest)
        private
        pure
        returns (bytes memory encoded)
    {
        bytes memory parameters = abi.encode(
            bytes32("1ss"),
            bytes32("home"),
            home,
            bytes32("guest"),
            guest
        );
        return parameters;
    }

    /// @dev main procedure to call oracle service
    function game_result() public onlyOwner {
        // init protocol contract
        Ask c = Ask(protocol);

        // these lines are demo code, so it's hardcoded
        bytes memory parameters = encode_parameters(
            bytes32("Qatar"),
            bytes32("Ecuador")
        );

        // do the request
        c.ask(anchor, address(this), this.anything.selector, parameters);
    }

    /// @dev callback fn for allowing protocol contract to set oracle result back
    function anything(bytes calldata data) public {
        require(
            msg.sender == owner() || msg.sender == protocol,
            "Unauhtorized!"
        );
        // decode the data here
        result = abi.decode(data, (uint256));
        // anything following
        closed = true;
    }

    function check() external view returns (bool needed) {
        needed = closed;
    }

    function modify() private {
        result = 110;
    }

    function perform() external {
        require(closed == true);
        modify();
        closed = false;
    }
}
