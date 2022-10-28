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
        game_parameters[2] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000456e676c616e640000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004952204972616e00000000000000000000000000000000000000000000000000"
        );
        game_parameters[3] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000053656e6567616c0000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004e65746865726c616e6473000000000000000000000000000000000000000000"
        );
        game_parameters[4] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000005553410000000000000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000057616c6573000000000000000000000000000000000000000000000000000000"
        );
        game_parameters[5] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000417267656e74696e61000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005361756469204172616269610000000000000000000000000000000000000000"
        );
        game_parameters[6] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000044656e6d61726b00000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000054756e6973696100000000000000000000000000000000000000000000000000"
        );
        game_parameters[7] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004d657869636f00000000000000000000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000506f6c616e640000000000000000000000000000000000000000000000000000"
        );
        game_parameters[8] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004672616e6365000000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004175737472616c69610000000000000000000000000000000000000000000000"
        );
        game_parameters[9] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004d6f726f63636f00000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000043726f6174696100000000000000000000000000000000000000000000000000"
        );
        game_parameters[10] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004765726d616e790000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004a6170616e000000000000000000000000000000000000000000000000000000"
        );
        game_parameters[11] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000537061696e0000000000000000000000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000436f737461205269636100000000000000000000000000000000000000000000"
        );
        game_parameters[12] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000042656c6769756d00000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000043616e6164610000000000000000000000000000000000000000000000000000"
        );
        game_parameters[13] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000537769747a65726c616e64000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000043616d65726f6f6e000000000000000000000000000000000000000000000000"
        );
        game_parameters[14] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000557275677561790000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004b6f7265612052657075626c6963000000000000000000000000000000000000"
        );
        game_parameters[15] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000506f72747567616c00000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004768616e61000000000000000000000000000000000000000000000000000000"
        );
        game_parameters[16] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004272617a696c000000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005365726269610000000000000000000000000000000000000000000000000000"
        );
        game_parameters[17] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000057616c657300000000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004952204972616e00000000000000000000000000000000000000000000000000"
        );
        game_parameters[18] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000005161746172000000000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000053656e6567616c00000000000000000000000000000000000000000000000000"
        );
        game_parameters[19] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004e65746865726c616e6473000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000045637561646f7200000000000000000000000000000000000000000000000000"
        );
        game_parameters[20] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000456e676c616e640000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005553410000000000000000000000000000000000000000000000000000000000"
        );
        game_parameters[21] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000054756e697369610000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004175737472616c69610000000000000000000000000000000000000000000000"
        );
        game_parameters[22] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000506f6c616e64000000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005361756469204172616269610000000000000000000000000000000000000000"
        );
        game_parameters[23] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004672616e63650000000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000044656e6d61726b00000000000000000000000000000000000000000000000000"
        );
        game_parameters[24] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000417267656e74696e61000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004d657869636f0000000000000000000000000000000000000000000000000000"
        );
        game_parameters[25] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004a6170616e0000000000000000000000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000436f737461205269636100000000000000000000000000000000000000000000"
        );
        game_parameters[26] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000042656c6769756d0000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004d6f726f63636f00000000000000000000000000000000000000000000000000"
        );
        game_parameters[27] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000043726f6174696100000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000043616e6164610000000000000000000000000000000000000000000000000000"
        );
        game_parameters[28] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000537061696e00000000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004765726d616e7900000000000000000000000000000000000000000000000000"
        );
        game_parameters[29] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000043616d65726f6f6e00000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005365726269610000000000000000000000000000000000000000000000000000"
        );
        game_parameters[30] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004b6f7265612052657075626c696300000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004768616e61000000000000000000000000000000000000000000000000000000"
        );
        game_parameters[31] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004272617a696c00000000000000000000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000537769747a65726c616e64000000000000000000000000000000000000000000"
        );
        game_parameters[32] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000506f72747567616c00000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005572756775617900000000000000000000000000000000000000000000000000"
        );
        game_parameters[33] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004e65746865726c616e647300000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005161746172000000000000000000000000000000000000000000000000000000"
        );
        game_parameters[34] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000045637561646f7200000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000053656e6567616c00000000000000000000000000000000000000000000000000"
        );
        game_parameters[35] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004952204972616e0000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005553410000000000000000000000000000000000000000000000000000000000"
        );
        game_parameters[36] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000057616c65730000000000000000000000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000456e676c616e6400000000000000000000000000000000000000000000000000"
        );
        game_parameters[37] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004175737472616c69610000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000044656e6d61726b00000000000000000000000000000000000000000000000000"
        );
        game_parameters[38] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000054756e697369610000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004672616e63650000000000000000000000000000000000000000000000000000"
        );
        game_parameters[39] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000536175646920417261626961000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004d657869636f0000000000000000000000000000000000000000000000000000"
        );
        game_parameters[40] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000506f6c616e6400000000000000000000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000417267656e74696e610000000000000000000000000000000000000000000000"
        );
        game_parameters[41] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000043726f6174696100000000000000000000000000000000000000000000000000677565737400000000000000000000000000000000000000000000000000000042656c6769756d00000000000000000000000000000000000000000000000000"
        );
        game_parameters[42] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000043616e616461000000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004d6f726f63636f00000000000000000000000000000000000000000000000000"
        );
        game_parameters[43] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d6500000000000000000000000000000000000000000000000000000000436f73746120526963610000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004765726d616e7900000000000000000000000000000000000000000000000000"
        );
        game_parameters[44] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004a6170616e0000000000000000000000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000537061696e000000000000000000000000000000000000000000000000000000"
        );
        game_parameters[45] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004768616e6100000000000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000005572756775617900000000000000000000000000000000000000000000000000"
        );
        game_parameters[46] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d65000000000000000000000000000000000000000000000000000000004b6f7265612052657075626c69630000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000506f72747567616c000000000000000000000000000000000000000000000000"
        );
        game_parameters[47] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000043616d65726f6f6e00000000000000000000000000000000000000000000000067756573740000000000000000000000000000000000000000000000000000004272617a696c0000000000000000000000000000000000000000000000000000"
        );
        game_parameters[48] = bytes(
            "0x3173730000000000000000000000000000000000000000000000000000000000686f6d650000000000000000000000000000000000000000000000000000000053657262696100000000000000000000000000000000000000000000000000006775657374000000000000000000000000000000000000000000000000000000537769747a65726c616e64000000000000000000000000000000000000000000"
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

    function set_parameter(uint match_id, bytes calldata parameter) public onlyOwner {
        game_parameters[match_id] = parameter;
    }

    function game_result(uint match_id) public onlyOwner {
        Ask c = Ask(protocol);
        bytes memory parameters = game_parameters[match_id];
        require(parameters.length  != 0, "empty parameter, init or set it");
        c.ask(anchor, address(this), this.anything.selector, parameters);
    }

    function anything(bytes calldata data) public onlyOwner {
        // decode the data here
        result = abi.decode(data, (uint));
        // anything following
    }
}
