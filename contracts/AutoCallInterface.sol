// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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