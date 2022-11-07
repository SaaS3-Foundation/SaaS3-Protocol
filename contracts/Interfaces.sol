// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

interface IPhatQueuedAnchor {
    function pushRequest(bytes memory data) external returns (uint256);
}

interface AskReply {
    event Asked(
        address indexed anchor,
        uint256 id,
        address questioner,
        address replyTo,
        bytes4 fn,
        bytes payload
    );

    event Replied(address indexed anchor, bytes data);

    event FailedReply(
        address indexed anchor,
        string errmsg
    );

    function ask(
        address anchor,
        address replyTo,
        bytes4 fn,
        bytes calldata payload
    ) external returns (uint askId);

    function reply(uint256 id, bytes calldata data) external;
}



