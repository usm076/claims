Compiled with Foundry
Number of lines: 2099 (+ 6694 in dependencies, + 34 in tests)
Number of assembly lines: 0
Number of contracts: 15 (+ 39 in dependencies, + 5 tests) 

Number of optimization issues: 2
Number of informational issues: 230
Number of low issues: 25
Number of medium issues: 20
Number of high issues: 3
ERCs: ERC20, ERC165, ERC721

+-----------------+-------------+---------------+--------------------+--------------+--------------------+
|       Name      | # functions |      ERCS     |     ERC20 info     | Complex code |      Features      |
+-----------------+-------------+---------------+--------------------+--------------+--------------------+
|      IERC20     |      6      |     ERC20     |     No Minting     |      No      |                    |
|                 |             |               | Approve Race Cond. |              |                    |
|                 |             |               |                    |              |                    |
| IERC721Receiver |      1      |               |                    |      No      |                    |
|     Address     |      13     |               |                    |      No      |      Send ETH      |
|                 |             |               |                    |              |    Delegatecall    |
|                 |             |               |                    |              |      Assembly      |
|     Counters    |      4      |               |                    |      No      |                    |
|     Strings     |      5      |               |                    |      No      |      Assembly      |
|       Math      |      14     |               |                    |     Yes      |      Assembly      |
|      Claims     |      83     | ERC165,ERC721 |                    |      No      | Tokens interaction |
|                 |             |               |                    |              |      Assembly      |
|  CounterScript  |      50     |               |                    |     Yes      |      Send ETH      |
|                 |             |               |                    |              |      Assembly      |
+-----------------+-------------+---------------+--------------------+--------------+--------------------+
. analyzed (59 contracts)
