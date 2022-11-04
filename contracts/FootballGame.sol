//SPDX-License-Identifier: MIT
// This demo contract is generated automatically by saas3
// EDIT it to adapt to your own dAPI
pragma solidity 0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ask.sol";
import "./AutoCallInterface.sol";
import "./Triggerable.sol";

contract FootballGame is Ownable, AutoCall, Triggerable {
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

    function bytes32ToString(bytes32 _bytes32)
        private
        pure
        returns (string memory)
    {
        uint8 i = 0;
        while (i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    string public home;
    string public guest;

    function stringToBytes32(string memory source)
        public
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function triggle(bytes calldata data) external returns (bool) {
        //(bytes32 _home, bytes32 _guest) = abi.decode(data, (bytes32, bytes32));
        (string memory _home, string memory _guest) = abi.decode(
            data,
            (string, string)
        );
        bytes32 h = stringToBytes32(_home);
        bytes32 g = stringToBytes32(_guest);
        home = bytes32ToString(h);
        guest = bytes32ToString(g);
        return false;
    }
}
