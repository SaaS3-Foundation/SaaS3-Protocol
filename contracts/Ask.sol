// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Interfaces.sol";
import "./PhatRollupReceiver.sol";

contract Ask is PhatRollupReceiver, AskReply, Ownable {

    /// @dev indecate req count
    uint next = 0;

    /// @dev Hash of expected reply parameters are kept to verify that
    /// the response will be done with the correct parameters.
    mapping(bytes32 => bytes32) private askIdToProof;

    /// @dev ask fn will push request to PhatQueuedAnchor contract
    /// contract address and fn selector should be passed in for callback
    function ask(
        address anchor,
        bytes32 endpointId,
        address replyTo,
        bytes4 fn,
        bytes calldata payload
    ) external override returns (bytes32 askId) {
        require(anchor != address(0), "anchor address not set");
        require(
            replyTo != address(this),
            "replyTo address cannot be Ask contract"
        );

        bytes memory req = abi.encodePacked(
            block.chainid,
            address(this),
            msg.sender,
            next,
            endpointId,
            replyTo,
            fn,
            payload
        );
        askId = keccak256(req);

        askIdToProof[askId] = keccak256(abi.encodePacked(replyTo, fn));

        IPhatQueuedAnchor(anchor).pushRequest(abi.encode(next, req));

        next++;
    }

    function onPhatRollupReceived(address _from, bytes calldata payload)
        public
        override
        returns (bytes4)
    {
        (
            uint id,
            bytes32 askId,
            address replyTo,
            bytes4 fn,
            bytes memory data
        ) = abi.decode(payload, (uint, bytes32, address, bytes4, bytes));

        require(
            keccak256(abi.encodePacked(replyTo, fn)) == askIdToProof[askId],
            "Invalid reply"
        );

        (bool ok, bytes memory ack) = replyTo.call(
            abi.encodeWithSelector(fn, askId, data)
        );
        if (ok) {
            emit Replied(_from, askId, ack);
        } else {
            emit FailedReply(
                _from,
                askId,
                "reply to caller contract fn failed"
            );
        }
        return ROLLUP_RECEIVED;
    }
}
