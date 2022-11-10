//SPDX-License-Identifier: MIT
// This demo contract is generated automatically by saas3
// EDIT it to adapt to your own dAPI
pragma solidity 0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Utils.sol";
import "./Interfaces.sol";

contract FootballGame is Ownable, Triggerable, Utils {
    /// @dev result, home, guest are only for test
    /// set them to public, so we can check directly
    /// There are two teams in a single match
    /// home vs guest
    /// result is 0 means home team lost and guest team win
    /// result is 1 means home team win and guest team lost
    /// result is 2 means draw
    uint256 public result;
    /// home team nanme
    string public home;
    /// guest team name
    string public guest;

    /// @dev saas3 protocol contract address
    address private oracle;

    /// @dev phala anchor contract address
    address private anchor;

    /// @dev we should not hardcode saas3 address in case of saas3 protocol contract upgrade
    function set_oracle(address oracle_addr, address phat_anchor_addr)
        external
        onlyOwner
    {
        oracle = oracle_addr;
        anchor = phat_anchor_addr;
    }

    /// @dev main procedure to call oracle service
    function ask(bytes32 _home, bytes32 _guest) private {
        /// @dev anchor will check in oracle contract, we don't need to check it here
        require(oracle != address(0), "oracle address not set");

        bytes memory parameters = super.encodeTeamNames(_home, _guest);

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

    function reply(bytes calldata data) external {
        require(
            msg.sender == owner() || msg.sender == oracle,
            "Unauhtorized msg sender!"
        );

        // meansing decode pending
        result = 110;

        // decode your result data here
        result = abi.decode(data, (uint256));

        // 结算逻辑
        // anything following

        if (result == 0) {
            // home lost
        } else if (result == 1) {
            // home win
        } else if (result == 2) {
            // draw
        } else {
            // unexpected case
        }
    }

    function triggle(bytes calldata data) external override returns (bool) {
        // TODO optimize data format to get rid of conversion
        (string memory _home, string memory _guest) = abi.decode(
            data,
            (string, string)
        );

        // these 2 lines are for test
        home = _home;
        guest = _guest;

        // call oracle service
        bytes32 h = super.stringToBytes32(_home);
        bytes32 g = super.stringToBytes32(_guest);
        ask(h, g);

        // If you don't know what is this for, just return false
        return false;
    }
}
