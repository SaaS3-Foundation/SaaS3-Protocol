// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Triggerable {
    /// @dev this fn will be called when specific event happens
    function triggle(bytes calldata data) external returns (bool retry);
}
