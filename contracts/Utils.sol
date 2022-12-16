//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;

/*
    Utilities & Common Modifiers
*/
contract Utils {
    /**
        constructor
    */
    constructor() {}

    /// @dev encode parameters to SaaS3 param specification
    /// this is used for FootballGame contract
    function encodeTeamNames(bytes32 home, bytes32 guest)
        internal
        pure
        returns (bytes memory encoded)
    {
        return
            abi.encode(
                bytes32("1ss"),
                bytes32("home"),
                home,
                bytes32("guest"),
                guest
            );
    }

    function bytes32ToString(bytes32 _bytes32)
        internal
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

    function stringToBytes32(string memory source)
        internal
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
}
