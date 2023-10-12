const AmiCatToken = artifacts.require('AmiCatToken')

contract('AmiCatToken', (accounts) => {
    it('token name equal Ami Cat', async () => {
        const amiCatTokenInstance = await AmiCatToken.deployed()
        const name = await amiCatTokenInstance.name.call()

        assert.equal(name, 'Ami Cat', 'token name NOT EQUAL Ami Cat')
    })

    it('Owner should have 5000 * 10 ** 18 token when initial', async () => {
        const amiCatTokenInstance = await AmiCatToken.deployed()
        const balance = await amiCatTokenInstance.balanceOf.call(accounts[0])

        assert.equal(
            balance,
            5000 * 10 ** 18,
            "5000 * 10 ** decimals() wasn't in the first account"
        )
    })

    it('Owner can mint token', async () => {
        const amiCatTokenInstance = await AmiCatToken.deployed()
        const account0 = accounts[0]

        const balance = await amiCatTokenInstance.balanceOf.call(account0)

        const mintAmount = web3.utils.toBN("50000000000000000000000")
        await amiCatTokenInstance.mint(mintAmount, {from: account0})
        const newBalance = await amiCatTokenInstance.balanceOf.call(account0)

        assert.equal(
            balance.add(mintAmount).eq(newBalance), true,
            'Error when owner mint token'
        )
    })
})
