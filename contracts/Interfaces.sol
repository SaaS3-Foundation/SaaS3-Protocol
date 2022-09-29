// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

interface IPhatQueuedAnchor {
    function pushRequest(bytes memory data) external returns (uint256);
}

interface AskReply {
    event Asked(
        bytes32 indexed askId,
        address indexed anchor,
        bytes32 endpointId,
        uint256 cnt,
        uint256 chainId,
        address questioner,
        address replyTo,
        bytes4 fn,
        bytes payload
    );

    event Replied(address indexed anchor, bytes32 indexed askId, bytes data);

    event FailedReply(
        address indexed anchor,
        bytes32 indexed askId,
        string errmsg
    );

    function ask(
        address anchor,
        bytes32 endpointId,
        address replyTo,
        bytes4 fn,
        bytes calldata payload
    ) external returns (bytes32 askId);
}
