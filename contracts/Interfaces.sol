// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

interface IPhatQueuedAnchor {
    function pushRequest(bytes memory data) external returns (uint256);
}

interface AskReply {
    event Asked(
        address indexed anchor,
        uint256 cnt,
        uint256 chainId,
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
}
