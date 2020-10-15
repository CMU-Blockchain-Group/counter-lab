# Solidity Counter Lab
Welcome to CMU Blockchain's first Solidity lab! In this lab, we will be having a hands-on learning experience with Solidity, Remix, MetaMask, and smart contracts. Here, you will build a basic counter smart contract, add some ownership features for "security", and then deploy on an Ethereum Testnet!

## Introduction
You're about to make your first Ethereum smart contract! While it won't be *that* useful practically, it'll still be an amazing, censorship-resistant, fully decentralized, single integer that's your very own! Hopefully, it'll also help you get started and get you started on how Solidity works.

We'll be walking through some initial code and then extend it with ownership protection and deploy to a Testnet. It would also be good to probably establish some baseline knowledge of what Solidity is, stolen from this beautiful [website](https://www.proofof.blog/2018/06/23/solidity.html).

> Solidity is a contract-oriented programming language, which is most often used on the Ethereum blockchain. Ethereum is a blockchain that has a virtual machine where the state of the virtual machine is copied over thousands of computers. To run programs on the ethereum virtual machine, you pay for the cost of computation and storage with the ether token. It is a global shared computer that enables us to create programs that are virtually impossible to shut down or stop. It is the platform that brought us ICOs, or initial coin offerings, a tool used to fund development of new ideas. You also can build dapps, or decentralized applications, using Solidity. Dapps are like websites that interact with Ethereum smart contracts. Lets get started with Remix.

Are we all good? Good.

## Table of Contents
> 1. [Setup](#setup)
> 2. [Starting Your Counter Smart Contract](#starting-your-counter-smart-contract)
> 3. [Compiling and Testing with Remix](#compiling-and-testing-with-remix)
> 4. [Adding Ownership](#adding-ownership)
> 5. [Deploying to Testnet](#deploying-to-testnet)

## Setup
For this lab, we'll be using [Remix](https://remix.ethereum.org/), an amazing fully-online IDE. It's a great place to get started leraning Solidity since no installation is necessary (no account needed either!).

Go ahead and open [Remix](https://remix.ethereum.org/) and get situated. If you've seen an IDE before, it should look pretty familiar, with a toolbar on the left side (including a file viewer) and the main code view on the right. There's also a small console on the bottom for when we get to testing.

[Remix](https://remix.ethereum.org/) starts with a few files already in your project. Since we'll be starting from scratch, go ahead and right click/delete all 4 files in the file viewer.

Once you've set up Remix, it would also be good (although optional) to get set up with Metamask, a crypto wallet that acts as a Chrome extension to let you interact with dapps + Ethereum testnets. Go ahead and install [Metamask](https://metamask.io/) and make a new account. We'll get into more Metamask stuff in section 5, but let's get right into coding.

## Starting Your Counter Smart Contract
We'll start with a simple smart contract that counts using a stored number. This counter should have a `add` function to count up one, a `reset` function to reset the count, and a `getCounter` getter to get the count.

To do this, we'll make a *smart contract* called `Counter`. Go ahead and make a new file called `Counter.sol` by clicking the plus button next to browser and stick this inside:
```
pragma solidity ^0.6.6;

contract Counter {
    /* Define counter of type integer */
    int counter;

    /* This runs when the contract is executed */
    constructor() public {
       counter = 0;
    }

    /* Resets counter to zero */
    function reset() public {
        counter = 0;
    }
    
    /* Simple function to add 1 to the counter */
    function add() public {
        counter += 1;
    }
    
    /* Returns the counter. Does not cost gas. */
    function getCounter() public view returns (int) {
        return counter;
    }
```
We'll break down this chunk of code section by section.
```pragma solidity ^0.6.6;```
> Programming langauges are constantly changing, sometimes with breaking changes. This line tells the Solidity compiler which version of Solidity the code is expected to be built against. This line means that the Solidity compiler version must be no lesser than 0.6.6 and must be less than 0.7.0.

`contract Counter {`
> Contracts in Solidity are structures that store data and allow functions to be defined. You can think of them as kind of like classes in a more normal programming language. Here, we're making a new contract called `Counter`

`int counter;`
> This is where we store the decentralized, uncensorable `counter` integer. Here, `counter` will be an integer stored by the contract

 ```
constructor() public {
    counter = 0;
}
```
> When a contract is created, the `constructor` is called exactly once, and never called again. This `constructor` will set the `counter` variable to 0, starting our counter.

```
function reset() public {
    counter = 0;
}
```
> The `reset` function is a *public* function, which means it can be called from any other contract/from anywhere else. In other labs, we'll see other modifiers like *external* or *private*. This function can be called to reset the counter to 0.

```
function add() public {
    counter += 1;
}
```
> Here, we're doing the heavy lifting of incrementing our `counter` by 1 each time this function is called.

```
function getCounter() public view returns (int) {
    return counter;
}
```
> This function is our getter, allowing us to get the value of our `counter`. One interesting thing to note is the `view` modifier of this function. This means that this function is not going to modify any data in our contract, and so does not require any other computer on the Ethereum network to do anything, as we can just pull the data from the blockchain ourselves.
> This means **this function won't cost any gas to execute**, as it takes no computational power. All of our other functions, as they change the state of the contract, will cost **gas** to execute, which is basically a fee paid in Ethereum for using EVM resources.

## Compiling and Testing with Remix
1. Go to the *compile* tab on Remix (the second one). Make sure `0.6.6+commit.6c089d02` is selected as the compiler, and go ahead and hit the big blue `Compile Counter.sol` button. This should be pretty fast, and you should see a green checkmark next to the compile tab once it's done.
2. Go to the *deploy and run* tab (right under the compile tab). Make sure your environment is set to `JavaScript VM` and hit the orange `Deploy` button. You should see an extra line in the `Deployed Contracts` section.
3. Expand the `COUNTER AT 0x...` line in the `Deployed Contracts` section. You should see two orange buttons (needs gas) for adding and resetting, as well as a blue button for `getCounter`. Each of these buttons will call the corresponding function in your contract. Try clicking these buttons a few times and see how the counter changes once you `getCounter`.

### A *small* problem
Ideally, even though our integer is decentralized, we'd like to make sure only the **owner** of this contract can reset the integer, to prevent someone from mucking around with the sanctity of our unstoppable counter! However, this protection doesn't exist in our current contract!

Try choosing another `ACCOUNT` from the dropdown. Notice that resetting the counter still works, even though this wasn't the original account that we deployed from! What to do?

## Adding Ownership
Luckily, lots of people want to do this too, so this is super easy. *OpenZeppelin*, a company that builds developer tools for distributed systems, has a very commonly used smart contract that supports ownership. You can have a look at it here: [Ownable.sol](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol).

We'll be importing this into our contract, and then using *contract inheritance* to make our contract ownable!

First, add this line right above your `contract Counter {` line:
`import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";`

> This line uses some Remix sugar to pull the file from GitHub and imports it into your contract like `#include` in C or `import` in Python.

Now, we can make two quick changes to our code to use this. First, we want to make `Counter`, our smart contract, inherit from `Ownable`. To do this, modify the `contract Counter {` line to say this:
`contract Counter is Ownable {`

> Basically, this line gives us access to all of the functions and *modifiers* defined in `Ownable`, making us able to define functions where we want only the owner to be allowed!

Finally, we want to make our `reset` function only callable by the owner. We can do this with a simple one line change, making use of the `onlyOwner` *modifier*. Change the reset line to this:
`function reset() public onlyOwner {`

> Adding `onlyOwner` as a modifier for our `reset` function means that `onlyOwner` from the `Ownable` contract will be called before `reset`. `onlyOwner` is a function that checks if the owner is calling, preventing `reset` from running if not! (more tutorials on modifiers coming soon!)

Now, try recompiling and redeploying, and enjoy your new, more secure Counter contract.

## Deploying to Testnet
More information coming soon!

## Next Steps
Now that we have our amazing counter, a good next step is to learn more about voting contracts or ERC20, Ethereum's most popular token standard.
