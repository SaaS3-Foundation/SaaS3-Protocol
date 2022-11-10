// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

interface IPhatQueuedAnchor {
    function pushRequest(bytes memory data) external returns (uint256);
}

interface IsAsking {
    event Asked(
        address anchor,
        uint256 id,
        address replyTo,
        bytes4 fn,
        bytes payload
    );

    event ReplyFailed(
        uint256 id,
        address replier,
        address replyTo,
        bytes4 fn,
        string errmsg,
        bytes payload
    );

    event Replied(
        uint256 id,
        address replier,
        address replyTo,
        bytes4 fn,
        bytes data
    );

    function ask(
        address anchor,
        address replyTo,
        bytes4 fn,
        bytes calldata payload
    ) external returns (uint askId);
}

interface Mo {
    function reply(uint256 id, bytes calldata data) external;
}

interface Triggerable {
    /// @dev this fn will be called when specific event happens
    function triggle(bytes calldata data) external returns (bool retry);
}

interface AutoCall {
    /**
     * @return needed boolean to indicate whether to call the perfrom fn
     */
    function check() external returns (bool needed);

    /**
     * @dev do perform
     */
    function perform() external;
}
